# 100kga work log

remove dup header
grep -v '^##' chr2.100KGA.1163sample.vcf | awk '!seen[$0]++' | bgzip > chr2.100KGA.1163.clean.vcf.gz

remove miss token rows in plink
```rm-bad-rows.sh```
