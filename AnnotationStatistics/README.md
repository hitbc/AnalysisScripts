AnnotationStatistics
======

The annotation statistics process for SNP uses the in-house script "annotationAnaysisSNP" and for SV the script "annotationAnaysisSV", these scripts can be found in  "AnalysisScripts/annotationAnaysis/". The analysis is divided into three processes, which are to count a piece of data and generate the result json file, then to merge all the results and generate the merged json file, and finally, to use the json file to generate a spreadsheet. The specific execution commands are as follows:

## Statistics of all SNPs:
(1)Execute annotation statistics, where "SNP_anno_file.txt" is the annotation result file, and "output_fn.json" is the statistics result.
```
./annotationAnaysisSNP anno_analysis SNP_anno_file.txt -1 > output_fn.json
```
(2)Results Merge.
```
find ../annotationAnaysisSNP_rst/* | grep json > all_json_file_list_SNP.txt
./annotationAnaysisSNP combine all_json_file_list_SNP.txt > all_combine.json
```
(3)Generate preadsheet.
```
./annotationAnaysisSNP SV_excel all_combine.json title_str > final_excel_SV.tsv
```

## Statistics on the number of variants in fixed-length window intervals
(1) Using 500/1000/10000/100000 as window lengths, count the number of variants in each window on each chromosome, and the number of variants distributed in each frequency class
```  
regulation_region/submit_find_out.py
```
(2) Combine all the analysis results in all windows
```
regulation_region/cmb_region_variants.py
```
(3) Split the results according to the frequency level
```
regulation_region/split_region_variants_col.py
```
(4) Sort the number of variants distributed in frequency classes and fetch the top 1000 windows with the most variants
```
regulation_region/submit_fetch_1000.py
```

## Statistics on the number of variants nearby promoter and enhancer region 
(1) Split the promoter and enhancer raw dependency dataset by chromosome for subsequent parallel analysis
```
regulation_region/split_regulation.py
```
(2) Count the variants located in the regulation region
```
regulation_region/submit_find_regu.py
```
(3) Combine the results of each chromosome
```
regulation_region/combine_regulation.py
```

## Statistics of the number of variants in gene regions
(1) Count the number of variants on each gene
```
submit_fetch_gene_nums.py
```
(2) Combine the statistical results
```
cmb_gene_nums.py
```

## Statistics of all SVs:
(1)Execute annotation statistics, where "SV_var.vcf" is the joint SV file, "annoteSV_sesult.tsv" is the annotation result generate by annoteSV, and "output_fn.json" is the statistics result.
```
./annotationAnaysisSV anno_analysis SV_var.vcf annoteSV_sesult.tsv -1 0 NULL output.json 
```
(2)Results Merge.
```
./annotationAnaysisSV combine all_json_file_list.txt > all_combine.json
```
(3)Generate preadsheet.
```
./annotationAnaysisSV SV_excel all_combine.json title_str > final_excel_SNP.tsv
```
