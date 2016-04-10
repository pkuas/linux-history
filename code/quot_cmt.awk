BEGIN{
        FS=";";
        OFS=";";
        numF=8;
}
{
        quot="\"";
        last=quot;
        if (NF==numF){
                last=quot""$NF""quot;
        }else{
                for(i=numF; i<NF;i+=1){
                        last=last""$i""FS;
                }
                last=last""$NF""quot;
        }
        print $1, $2, $3, $4, $5, $6, $7, last;
}
