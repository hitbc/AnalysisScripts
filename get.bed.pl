#open IN,"@ARGV[0]";
open(IN,"gzip -dc @ARGV[0]|") or die ("can not open $infilename\n");
open OUT,">@ARGV[1]";
while(<IN>)
{
if($_=~/^\#/){next;}
s/\r|\n//g;
@a=split/\t/,$_;
$end=$a[1]+1;
$hou=join("&",@a[2..$#a]);
print OUT "chr$a[0]\t$a[1]\t$end\t$hou\n";


}
