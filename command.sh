IMG=vfarcic/go-demo-2

TAG=1.0

cat go-demo-2.yml | sed -e "s@image: $IMG@image: $IMG:$TAG@g" | kubectl create -f -

kubectl rollout status deploy go-demo-2-api

curl -H "Host: go-demo-2.com" "http://$(minikube ip)/demo/hello"

kubectl get all

kubectl get ns

kubectl --namespace kube-public get all

## Creating new Namespaces
kubectl create ns testing

kubectl get ns

# Create a ne context for new namespace
kubectl config set-context testing --namespace testing --cluster minikube --user minikube
# created context called testing

# 
kubectl config view
# now we have two context we can switch to testing context
 kubectl config use-context testing
# from now onwards all kubectl commands will be executed within testing namespace context.
 kubectl get all

TAG=2.0

DOM=go-demo-2.com

cat go-demo-2.yml | sed -e "s@image: $IMG@image: $IMG:$TAG@g" | sed -e "s@host: $DOM@host: $TAG\.$DOM@g" | kubectl create -f -

kubectl rollout status deploy go-demo-2-api

curl -H "Host: go-demo-2.com" "http://$(minikube ip)/demo/hello"

curl -H "Host: 2.0.go-demo-2.com" "http://$(minikube ip)/demo/hello"

## Communication between namespaces

kubectl config use-context minikube

kubectl run test --image=alpine --restart=Never sleep 10000

kubectl get pod test

kubectl exec -it test -- apk add -U curl

kubectl exec -it test -- curl "http://go-demo-2-api:8080/demo/hello"

kubectl exec -it test -- curl "http://go-demo-2-api.testing:8080/demo/hello"

## Deleting Namespace and all its objects

kubectl get ns

kubectl delete ns testing

kubectl -n testing get all

kubectl get all

kubectl exec -it test -- curl "http://go-demo-2-api:8080/demo/hello"

kubectl set image deployment/go-demo-2-api api=vfarcic/go-demo-2:2.0 --record