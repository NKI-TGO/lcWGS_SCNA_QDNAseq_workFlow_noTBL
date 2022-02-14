#!/bin/bash



for i in *markdup.bam

do

echo "indexing: "$i

samtools index $i $i".bai"

done
