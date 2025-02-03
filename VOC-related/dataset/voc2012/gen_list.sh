#!/bin/bash

LABEL=$1
rm -f ${LABEL}_trainaug.txt
rm -f VOC_test.txt
for filename in $(cat trainaug.txt)
do
	echo "JPEGImages/$filename.jpg SegmentationClassAug/$filename.png" >> ${LABEL}_trainaug.txt
done

for filename in $(cat train.txt)
do
	echo "JPEGImages/$filename.jpg SegmentationClass/$filename.png" >> ${LABEL}_trainaug.txt
done

for filename in $(cat val.txt)
do
	echo "JPEGImages/$filename.jpg SegmentationClass/$filename.png" >> VOC_test.txt
done

