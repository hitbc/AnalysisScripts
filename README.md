# AnalysisScripts

Leadership: Tao Jiang and Yadong Liu

## Alignment 
Anqi Zhang

## Variant Calling based on short-reads
Anqi Zhang

## Variant Calling based on long-reads
Ming Chen

## Functional Annotation
Dianming Liu, Siyuan Liu

### Download Dataset
#### 1. AnnoVar Datasets
Some datasets we need for annotation are already included in AnnoVar, we can download them via its download script provided by AnnoVar.
Example: `perl annotate_variation.pl -downdb -webfrom annovar -buildver hg38 refGene humandb/`  
Datasets downloaded by this way: refGene, exac03, dbnsfp41c, intervar_20180118, 1000g2015aug, avsnp150, etc.
#### 2. CADD Datasets
CADD datasets can be downloaded via its download page at https://cadd.gs.washington.edu/download.  
It should be noted that the dataset files for different genome builds with the same release version have different annotaion items.  
We used both GRCh37 and GRCh38 datasets of release v1.6.
#### 3. UCSC Datasets
UCSC datasets could be downloaded via its FTP site at <ftp://hgdownload.soe.ucsc.edu/goldenPath>.  
Datasets downloaded by this way: phastCons20way, phastCons100way, phyloP20way, phyloP100way, etc.
#### 4. Ensembl Dataset
Ensembl dataset could be found and downloaded via its FTP site at <ftp://ftp.ensembl.org/pub>.

### LiftOver
Some datasets in build GRCh37 need to be converted into build GRCh38 via liftover.  
Usage: `liftOver oldFile map.chain newFile unMapped`

### Convert datasets into avinput format
Avinput format file is the standard input file for AnnoVar, datasets downloaded via AnnoVar all in this format. Insertion and deletion variants were specially processed in this format which cannot be reconverted. In this case, we need to convert all datasets into avinput format via the convert script provided by AnnoVar.  
Example: `perl convert2annovar.pl -format vcf4 variantfile > variant.avinput`

### Indexing datasets for VarNote annotation
All datasets besides gene-based datasets(e.g. refGene) will be used in VarNote annotation procedure, which means that they need to be properly indexed.
Example:
```
bgzip hg38_exac03.txt  
java -jar VarNote-1.1.0.jar Index -I:tab,c=1,b=2,e=3,ref=4,alt=5 hg38_exac03.txt.gz
```

### Annotation
#### 1. Convert Format
All datasets have been processed into avinput format. For consistency, we need to convert input vcf file into avinput format for further annotation as well. This can also be done through the AnnoVar script.  
Example: `perl convert2annovar.pl -format vcf4 example.vcf > example.avinput`
#### 2. AnnoVar Annotation
We use AnnoVar for gene-based annotation, typically refGene.  
Example: `perl table_annovar.pl example.avinput humandb/ -buildver hg38 -out example -protocol refGene -operation g -nastring . -remove`
#### 3. VarNote Annotation
We use VarNote for filter-based and region-based annotation. Considering the large number of datasets involved, we use the configuration file to specify the name of the annotation item.  
Example: `java -jar VarNote-1.1.0.jar Annotation -Q:tab,c=1,b=2,e=3,ref=4,alt=5 example.avinput -D:db,tag=exac03,mode=1 hg38_exac03.txt.gz -D:db,tag=cage_enhancers,mode=0 hg38_cage_enhancers.bed.gz -O example -OF BED -T 16 -A example.cfg -Z False -loj True -MVL 500`


## Population genetic analysis
Yang Li

## Statistical Analysis
Gaoyang Li

## Reference panel construction and imputation performing
Yadong Liu

