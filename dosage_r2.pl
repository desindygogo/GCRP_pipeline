#!usr/bin/perl -w
use Statistics::Basic qw(:all);
open TRUEVCF , "<$ARGV[0]";
open IMPUTVCF , "<$ARGV[1]";
open OUTPUT, ">$ARGV[2]";
@real2=();
@imp2=();
<TRUEVCF>;
<IMPUTVCF>;
while (<TRUEVCF>){
        chomp;
        ($snpid,@genotype_t) = split /\t/ , $_;
        chomp($imput = <IMPUTVCF>);
        ($snpid2,@genotype_i) = split /\t/ , $imput;
        for($i=0;$i<=$#genotype_t;$i++){
                if($genotype_t[$i] > 0){
                        push @real2,$genotype_t[$i];
                        push @imp2,$genotype_i[$i];
                }
        }
        if($#imp2 >=3){
                $cor = (correlation(\@genotype_i , \@genotype_t))**2;
                print OUTPUT "$snpid\t$cor\n";
        }
        @real2=();
        @imp2=();
}
close TRUEVCF ;
close IMPUTVCF ;
