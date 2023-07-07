VOCEA
===================

This repository contains code for the paper "Visual Quality Optimization on the Quantization Table in JPEG Compression With Dual Population Based Co-Evolutionary Algorithm"

The main program of the code is vocea.m,The population algorithm with constraints is constrain_tcsvt.m,The population algorithm without constraints is oldconstriant_TCSVT.m.



The comparison methods include:
1. RDOEA.  Rate–distortion optimal evolutionary algorithm for JPEG quantization with multiple rates, Knowledge-based Systems, 2022.
2. PsyQ. The optimal quantization matrices for JPEG image compression from psychovisual threshold, J. Theor. Appl. Inf. Technol. 70(3) (2014) 566–572.
3. SA. Simulated annnealing for JPEG quantization, 2017, arXiv preprint arXiv:1709.00649.
4. ASC. A multi-objective evolutionary approach to image quality/compression ratio trade-off in JPEG baseline algorithm, Appl. Soft Comput. 10 (2) (2010) 548–561.

 **Performance**

 Subjective quality comparison of decompressed images

 

![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/jpeg/jpeg_kodim24_0.2.png) Kodim24 jpeg rate=0.1986 dss=0.39 ssim=0.6657 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/psyq/psyq_kodim24_0.2.png) psyq rate=0.2043 dss=0.3989 ssim=0.6777 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/sa/sa_kodim24_0.2.png) sa rate=0.2054 dss=0.4387 ssim=0.6679 |
| :----------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/rdoea/rdoea_kodim24_0.2.png) rdoea rate=0.1999 dss=0.4013 ssim=0.6652 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/vocea/vocea_kodim24_0.2.png) vocea rate=0.1958 dss=0.4659 ssim=0.6555 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/jpeg/jpeg_kodim16_0.2.png) Kodim16 jpeg rate=0.2057	dss=0.54769 ssim=0.7678 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/psyq/psyq_kodim16_0.2.png) psyq rate=0.2056	dss=0.6345 ssim=0.7761 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/sa/sa_kodim16_0.2.png) sa rate=0.2033	dss=0.6193 ssim=0.7694 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/rdoea/rdoea_kodim16_0.2.png) rdoea rate=0.2057	dss=0.5736 ssim=0.7617 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/vocea/vocea_kodim16_0.2.png) Vocea rate=0.2009 dss=0.6445 ssim=0.744 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/jpeg/jpeg_kodim11_0.2.png) kodim11 jpeg rate=0.2006 dss=0.5076 ssim=0.7097 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/psyq/psyq_kodim11_0.2.png) psyq rate=0.2055	dss=0.5053 ssim=0.7225 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/sa/sa_kodim11_0.2.png) sa rate=0.20016	dss=0.5248 ssim=0.7111 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/rdoea/rdoea_kodim11_0.2.png) rdoea rate=0.2048  dss=0.5228 ssim=0.7183 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/vocea/vocea_kodim11_0.2.png) vocea rate=0.2054 dss=0.603 ssim=0.7093 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/jpeg/jpeg_kodim13_0.2.png) kodim13 jpeg rate=0.2144 dss=0.2845 ssim=0.5005 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/psyq/psyq_kodim13_0.2.png) psyq rate=0.1969	dss=0.2509 ssim=0.485 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/sa/sa_kodim13_0.2.png)  sa rate=0.2110	dss=0.3691 ssim=0.485 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/rdoea/rdoea_kodim13_0.2.png) rdoea rate=0.2073	dss=0.3124 ssim=0.4849 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/vocea/vocea_kodim13_0.2.png) vocea rate=0.2016	 dss=0.4655 ssim=0.4613 |                                                              |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/jpeg/jpeg_kodim21_0.2.png) kodim21 jpeg rate=0.2011 dss=0.4512 ssim=0.7649 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/psyq/psyq_kodim21_0.2.png) psyq rate=0.2067	dss=0.4618 ssim=0.7773 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/sa/sa_kodim21_0.2.png)  sa rate=0.20443	dss=0.5073 ssim=0.7722 |
| ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/rdoea/rdoea_kodim21_0.2.png) rdoea rate=0.2009	 dss= 0.5018 ssim=0.7814 | ![img](https://github.com/CCchuxin/VOCEA/blob/main/compression%20results/vocea/vocea_kodim21_0.2.png) vocea rate=0.2049 dss=0.5392 ssim=0.7635 |                                                              |

 
