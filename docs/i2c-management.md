# i2c Cluster Management

```bash
# Bits  : 76543210
# Slots : 5674321x

# Power off worker nodes 2,3,4,5,6,7
sudo i2cset -m 0xfc -y 1 0x57 0xf2 0x00

# Power on worker nodes
sudo i2cset -m 0xfc -y 1 0x57 0xf2 0xff

# 0x02 : Node #1 (Master)
# 0x04 : Node #2 (Worker 1)
# 0x08 : Node #3 (Worker 2)
# 0x10 : Node #4 (Worker 3)
# 0x80 : Node #5 (Worker 4)
# 0x40 : Node #6 (Worker 5)
# 0x20 : Node #7 (Worker 6)

# Power off node #3
sudo i2cset -m 0x08 -y 1 0x57 0xf2 0x00

# Power on node #7
sudo i2cset -m 0x20 -y 1 0x57 0xf2 0xff

# read on/off status
sudo i2cget -y 1 0x57 0xf2
0xff
```