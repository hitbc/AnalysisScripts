annotationAnaysis
======

The annotation statistics process for SNP uses the in-house script "annotationAnaysisSNP" and for SV the script "annotationAnaysisSV", these scripts can be found in  "AnalysisScripts/annotationAnaysis/". The analysis is divided into three processes, which are to count a piece of data and generate the result json file, then to merge all the results and generate the merged json file, and finally, to use the json file to generate a spreadsheet. The specific execution commands are as follows:

## For SNPs:
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

## For SVs:
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
