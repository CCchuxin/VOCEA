VOCEA
===================

This repository contains code for the paper "Visual Quality Optimization on the Quantization Table in JPEG Compression With Dual Population Based Co-Evolutionary Algorithm"

The main program of the code is vocea.m,The population algorithm with constraints is constrain_tcsvt.m,The population algorithm without constraints is oldconstriant_TCSVT.m.



 

 **Performance**

 Subjective quality comparison of decompressed images

 

![image](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/jpeg/jpeg_kodim24_0.2.png) Kodim24 jpeg rate=0.2038 dss=0.6851 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/psyq/psyq_kodim24_0.2.png) psyq rate=0.2005 dss=0.7625 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/sa/sa_kodim24_0.2.png) sa rate=0.2003  dss=0.7438 |
| :----------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/rdoea/rdoea_kodim24_0.2.png) rdoea rate=0.2084 dss=0.7071 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/vocea/vocea_kodim24_0.2.png) vocea rate=0.1995 dss=0.7822 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/jpeg/jpeg_kodim16_0.2.png) Kodim16 jpeg rate=0.2057	dss=0.54769 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/psyq/psyq_kodim16_0.2.png) psyq rate=0.2056	dss=0.6345 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/sa/sa_kodim16_0.2.png) sa rate=0.2033	dss=0.6193 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/rdoea/rdoea_kodim16_0.2.png) rdoea rate=0.2057	dss=0.54769 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/vocea/vocea_kodim16_0.2.png) Vocea rate=0.2007 dss=0.6744 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/jpeg/jpeg_kodim11_0.2.png) kodim11 jpeg rate=0.2006 dss=0.4649 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/psyq/psyq_kodim11_0.2.png) psyq rate=0.2055	dss=0.5053 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/sa/sa_kodim11_0.2.png) sa rate=0.20016	dss=0.5248 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/rdoea/rdoea_kodim11_0.2.png) rdoea rate=0.2048  dss=0.5145 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/vocea/vocea_kodim11_0.2.png) vocea rate=0.2054 dss=0.5659 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/jpeg/jpeg_kodim13_0.2.png) kodim13 jpeg rate=0.2144 dss=0.2529 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/psyq/psyq_kodim13_0.2.png) psyq rate=0.2055	dss=0.5053 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/sa/sa_kodim13_0.2.png)  sa rate=0.2110	dss=0.3691 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/rdoea/rdoea_kodim13_0.2.png) rdoea rate=0.2073	dss=0.3199 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/vocea/vocea_kodim13_0.2.png) vocea rate=0.2016	 dss=0.45208 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/jpeg/jpeg_kodim21_0.2.png) kodim21 jpeg rate=0.2011 dss=0.400 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/psyq/psyq_kodim21_0.2.png) psyq rate=0.2067	dss=0.4618 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/sa/sa_kodim21_0.2.png)  sa rate=0.20443	dss=0.5073 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/rdoea/rdoea_kodim21_0.2.png) rdoea rate=0.2009	 dss= 0.4103 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/%E5%9B%BE%E5%83%8F%E5%8E%8B%E7%BC%A9%E7%BB%93%E6%9E%9C/vocea/vocea_kodim21_0.2.png) vocea rate=0.2049 dss=0.5246 |                                                              |

 
