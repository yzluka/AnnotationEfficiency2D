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
		bash tool/test.sh voc2012 pspnet101 | tee temp.out
		echo "${styl}_${mult}_${model_path}" >> ${styl}.out
		cat temp.out| grep mIoU/mAcc >> ${styl}.out
		sed -i "s/model_path: ${model_path//\//\\/}/model_path:/g" config/voc2012/voc2012_pspnet101.yaml
	done

	mv exp/voc2012/pspnet101/ model_checkpoints/exp_${styl}${mult}_pspnet101
}


styl="scribsamv2"
for spec in 1,192 2,128 4,85 8,57 10,50
do
	config_and_train
done


