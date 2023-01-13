# make appropriate changes before running the scripts
IMAGE=indrajeet_io
CONTAINER=indrajeet_io
AVAILABLE_GPUS='3'
LOCAL_JUPYTER_PORT=15000
LOCAL_TENSORBOARD_PORT=15001
VSCODE_PORT=15002
MATLAB_PORT=15003
PASSWORD=Hello
WORKSPACE=/home/indrajeet/Github
#TB_PATH=/notebooks/STL2/src/SOTA/lightning_logs/
# END OF CONFIG  =============================================================================================================

docker-resume:
	docker start -ai $(CONTAINER)

docker-stop:
	docker stop $(CONTAINER)

docker-run:
	#docker image pull $(IMAGE)
#	NV_GPU=$(AVAILABLE_GPUS) nvidia-docker run -it -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p $(LOCAL_TENSORBOARD_PORT):6006 -p $(R_STUDIO_PORT):8787 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE)
	docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it \
		-e PASSWORD=$(PASSWORD) -e JUPYTER_TOKEN=$(PASSWORD) \
		-e JUPYTER_ENABLE_LAB=yes\
		-p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p $(LOCAL_TENSORBOARD_PORT):6006 \
		-v $(WORKSPACE):/notebooks --name $(CONTAINER) $(IMAGE)
#	-u $(shell id -u ${rsreeni1}):$(shell id -g ${rsreeni1}) 

docker-shell:
	docker exec -it $(CONTAINER) bash

docker-tensorboard:
	docker exec -it $(CONTAINER) tensorboard --logdir=$(TB_PATH) --host 0.0.0.0

docker-clean:
	docker rm $(CONTAINER)

docker-build:
	docker build -t $(IMAGE) .

docker-vscode:
	docker exec -it $(CONTAINER) code-server --port 8443 --auth password --disable-telemetry /notebooks	
#nvidia-docker exec -it $(CONTAINER) code-server --disable-telemetry -d /vscode /notebooks
#nvidia-docker exec -it $(CONTAINER) code-server -p 8080 --disable-telemetry -d /vscode /notebooks

docker-matlab-run:
		docker run --gpus '"device=$(AVAILABLE_GPUS)"' -it -e PASSWORD=$(PASSWORD) -p $(MATLAB_PORT):6080 --shm-size=512M \
		       	-e MLM_LICENSE_FILE=1701@license5.umbc.edu -v $(shell pwd):/notebooks --name matlab_test nvcr.io/partners/matlab:r2020a

docker-push:
	docker push $(IMAGE)
