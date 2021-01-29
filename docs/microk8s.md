# Kubernetes Setup on 20.04 Cluster:
https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#1-overview

## Preface
Running ubuntu 20.04 server images concurrently on a turingpi appears to be somewhat unexplored in the cloud native community. I have had problems booting ubuntu 20.04 images on the turingpi simultanueosly (i.e. turning on the turingpi motherboard with all the nodes in place). The nodes just started bootlooping. After inspecting the boot logs it appears that the nodes are all fighting for the same ethernet address on the bus (since the turingpi shares one ethernet switch chip )? This is just a loose assumption and has not been explored deeply at this time. I was able to circumvent this issue by booting each node individually by starting with the only the master node connected, waiting for it to boot followed by the remaining slave nodes one-by-one. Its possible to add a grub timeout to each node and have them boot sequentially to alleivate the problem.

## Microk8s

Install `microk8s` through the snap store:
```bash
sudo snap install microk8s --classic
```

Add `incuvers-tp` to the `microk8s` group and change ownership:
```bash
sudo usermod -aG microk8s incuvers-tp
sudo chown -fR incuvers-tp ~/.kube
```

