#1.Data pre-processing
##Filter the SNP：
for i in {1..22};
    do /home/user/hitbio/software/bcftools/1.9/bin/bcftools view -v snps /home/user/hitbio/resultsdata/batch2/eagle/batch2/chr$i/batch2.chr$i.vcf -Oz -o /home/user/liuyue/test_1004samples/smc_test/$i.chr$i.snp.vcf.gz;
done

##Create index：
for i in {1..22};
    do /home/user/liuyue/tabix-0.2.6/tabix -p vcf $i.chr$i.snp.vcf.gz;
done

#Build the VCF files with three groups of samples ：
for i in {1..22};
    do /home/user/hitbio/software/bcftools/1.9/bin/bcftools view -S 3distinct_samplelist.txt $i.chr$i.snp.vcf.gz -Oz -o chr$i.snp.sample_filted.vcf.gz;
done

#2.Format conversion：
for i in {1..22};
smc++ vcf2smc /example/example.vcf.gz /example/north.chr*.smc.gz * pop1:msp_0,msp_1,msp_2,msp_3,msp_4
smc++ vcf2smc /example/example.vcf.gz /example/sourth.chr*.smc.gz * pop2:msp_0,msp_1,msp_2,msp_3,msp_4
smc++ vcf2smc /example/example.vcf.gz /example/tibet.chr*.smc.gz * pop3:msp_0,msp_1,msp_2,msp_3,msp_4
done
#3.Perform effective population size estimation：
for i in {1..22};
smc++ estimate --cores 12 --base north -o /example 1.25e-8 /example/north.chr*.smc.gz
smc++ estimate --cores 12 --base sourth -o /example 1.25e-8 /example/sourth.chr*.smc.gz
smc++ estimate --cores 12 --base tibet -o /example 1.25e-8 /example/tibet.chr*.smc.gz
done
#4.Draw the result diagram：
for i in {1..22};
smc++ plot -g 29 /example/plot.pdf /example/north.final.json /example/sourth.final.json /example/tibet.final.json
done

