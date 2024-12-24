# 100kga work log
#/vast/palmer/pi/reilly/jfa38/100kGA_samples/GAsP_1163Samples.SNVs.Feb2020.vcf.gz


remove dup header
grep -v '^##' chr2.100KGA.1163sample.vcf | awk '!seen[$0]++' | bgzip > chr2.100KGA.1163.clean.vcf.gz

remove miss token rows in plink
```rm-bad-rows.sh```
