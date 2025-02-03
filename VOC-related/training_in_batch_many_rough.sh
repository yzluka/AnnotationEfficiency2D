#!/bin/bash

target_file=dataset/voc2012/many_rough_temp.txt
target_yaml=config/voc2012/voc2012_pspnet101.yaml

function config_and_train(){
	rm -rf exp
	IFS=',' read hour epoch <<< "${spec}"
	echo "VOC_rough${IOU}_${hour}h" >> many_rough_all_eval.out
	cp dataset/voc2012/many_rough_filelists/${hour}h.txt $target_file
	sed -i "s/perfe/rough${IOU}/g" $target_file

	cp config/voc2012/voc2012_pspnet101.yaml_rough $target_yaml
	sed -i "s/epochs:/epochs: ${epoch}/g" $target_yaml
	sed -i "s/evaluate: False/evaluate: True/g" $target_yaml
	
	bash tool/train.sh voc2012 pspnet101
	

	for model_path in $(ls exp/voc2012/pspnet101/model/*.pth)
	do	
		sed -i "s/model_path:/model_path: ${model_path//\//\\/}/g" config/voc2012/voc2012_pspnet101.yaml
		bash tool/test.sh voc2012 pspnet101 > temp.out
		cat temp.out| grep mIoU/mAcc >> many_rough_all_eval.out
		sed -i "s/model_path: ${model_path//\//\\/}/model_path:/g" config/voc2012/voc2012_pspnet101.yaml
	done

	#mv exp/voc2012/pspnet101/ model_checkpoints/rough${IOU}_${hour}_pspnet101
}


for IOU in 81 84 87 90 93
do
	for spec in 20,112 40,75 60,64 80,50
	do
		config_and_train
	done
done

