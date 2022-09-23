
open IN,"@ARGV[0]";
open OUT,">>@ARGV[1]";
open(IN1,"gzip -dc @ARGV[2]|") or die ("can not open $infilename\n");
while(<IN1>)
{
if($_=~/^\#/){print OUT "$_";}
#else{last;}

}


while(<IN>)
{
s/\r|\n//g;
@a=split/\t/,$_;
@b=split/&/,$a[-1];
print OUT "$a[0]\t$a[1]\t";
print OUT join("\t",@b);
print OUT "\n";

}
