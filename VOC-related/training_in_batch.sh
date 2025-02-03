#!/bin/bash

function config_and_train(){
	rm -rf exp
	IFS=',' read mult epoch <<< "${spec}"
	target_file=config_customized/voc2012_pspnet101_${styl}_${mult}_${epoch}.yaml

	cp config/voc2012/voc2012_pspnet101.yaml_sample $target_file
	sed -i "s/epochs:/epochs: ${epoch}/g" $target_file
	sed -i "s/train_filelists\//train_filelists\/${styl}_${mult}_trainaug.txt/g" $target_file
	sed -i "s/evaluate: False/evaluate: True/g" $target_file
	#sed -i "s/_50.pth/_${epoch}.pth/g" $target_file

	cp $target_file  config/voc2012/voc2012_pspnet101.yaml
	bash tool/train.sh voc2012 pspnet101
	for model_path in $(ls exp/voc2012/pspnet101/model/*.pth)
	do
		sed -i "s/model_path:/model_path: ${model_path//\//\\/}/g" config/voc2012/voc2012_pspnet101.yaml
		bash tool/test.sh voc2012 pspnet101 > temp.out
		echo "${styl}_${mult}_${model_path}" >> all_eval.out
		cat temp.out| grep mIoU/mAcc >> all_eval.out
		sed -i "s/model_path: ${model_path//\//\\/}/model_path:/g" config/voc2012/voc2012_pspnet101.yaml
	done

	mv exp/voc2012/pspnet101/ model_checkpoints/exp_${styl}${mult}_pspnet101
}



styl="perfe"
#(multiplicity,epochs)
for spec in 1,493 2,329 4,219 8,146 16,97 32,65
do
	config_and_train
done

styl="poly+"
for spec in 1,448 2,299 4,199 8,132 16,89 32,59
do
	config_and_train
done

styl="poly-"
for spec in 1,253 2,169 4,113 8,75
do
	config_and_train
done

styl="rough"
for spec in 1,239 2,159 4,106 8,71
do
	config_and_train
done

styl="bbox"
for spec in 1,192 2,128 4,85 8,57
do
	config_and_train
done

