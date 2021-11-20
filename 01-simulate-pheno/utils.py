import pandas as pd
import numpy as np
import dapgen
import dask.array as da
import admix


def simulate_quant_pheno(
    bfile_list, hsq, causal_prop, out_prefix, hermodel="gcta", n_sim=100
):
    """
    Simulate quantitative phenotypes from a list of bfiles (from different chromosomes)

    Parameters
    ----------
    bfile_list : list
        List of bfiles (from different chromosomes), each bfile <bfile> is accompanied
        by frequency file <bfile>.freq.
    hsq : float
        Heritability
    causal_prop : float
        Proportion of causal variants
    out_prefix : str
        Prefix for output files <out_prefix>.beta.tsv, <out_prefix>.pheno_g.tsv, and
        <out_prefix>.pheno.tsv will be created.
    """
    geno = []
    df_indiv = None
    df_snp = []
    df_freq = []

    for bfile in bfile_list:
        this_geno, this_df_snp, this_df_indiv = dapgen.read_bfile(bfile, snp_chunk=1024)
        if df_indiv is None:
            df_indiv = this_df_indiv
        else:
            assert df_indiv.equals(
                this_df_indiv
            ), ".fam should be consistent for all bfiles"
        df_freq.append(
            pd.read_csv(bfile + ".freq", delim_whitespace=True).set_index("ID")
        )
        geno.append(this_geno)
        df_snp.append(this_df_snp)

    geno = da.concatenate(geno, axis=0)
    df_snp = pd.concat(df_snp)
    df_freq = pd.concat(df_freq)
    assert np.all(df_snp.index == df_freq.index), "SNP names should be consistent"
    assert (
        len(set(df_indiv.index)) == df_indiv.shape[0]
    ), "df_indiv.index should be unique"

    df_snp["FREQ"] = df_freq["ALT_FREQS"].values
    assert df_snp["FREQ"].isna().any() == False

    snp_prior_var = admix.data.calc_snp_prior_var(df_snp, hermodel)
    print(snp_prior_var)

    n_snp, n_indiv = geno.shape
    n_causal = int(n_snp * causal_prop)
    print(f"n_snp={n_snp}, n_indiv={n_indiv}, n_causal={n_causal}")

    sim = admix.simulate.quant_pheno_1pop(
        geno=geno, hsq=hsq, n_causal=n_causal, n_sim=n_sim, snp_prior_var=snp_prior_var
    )

    df_beta = pd.DataFrame(
        sim["beta"], columns=[f"SIM_{i}" for i in range(n_sim)], index=df_snp.index
    )
    df_beta = pd.concat([df_snp, df_beta], axis=1)

    df_pheno_g = pd.DataFrame(
        sim["pheno_g"], columns=[f"SIM_{i}" for i in range(n_sim)], index=df_indiv.index
    )
    df_pheno_g = pd.concat([df_indiv, df_pheno_g], axis=1)

    df_pheno = pd.DataFrame(
        sim["pheno"], columns=[f"SIM_{i}" for i in range(n_sim)], index=df_indiv.index
    )
    df_pheno = pd.concat([df_indiv, df_pheno], axis=1)

    for suffix, df in zip(
        ["beta", "pheno_g", "pheno"], [df_beta, df_pheno_g, df_pheno]
    ):
        df.to_csv(f"{out_prefix}.{suffix}.tsv.gz", sep="\t")