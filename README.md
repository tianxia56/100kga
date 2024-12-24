# 100kga work log
#/vast/palmer/pi/reilly/jfa38/100kGA_samples/GAsP_1163Samples.SNVs.Feb2020.vcf.gz

first ```extract_chr.sh```

second remove dup header
grep -v '^##' chr2.100KGA.1163sample.vcf | awk '!seen[$0]++' | bgzip > chr2.100KGA.1163.clean.vcf.gz

third remove miss token rows in plink
```rm-bad-rows.sh```

then pca

admixture:
```$plink --bfile ../all.bfile/merged_data --indep-pairwise 200 50 0.25 --out pruned_data```

```$plink --bfile ../all.bfile/merged_data --extract pruned_data.prune.in --make-bed --out ld_pruned_data```



