---
title: "(GoogLeNet) Going deeper with convolutions 리뷰"
date: 2024-10-22
layout: post
categories: 
- AI-Research
tags: 
- vision
---

<img itemprop="image" src="https://000namc.xyz/nginx/blog/googlenet/figure1.jpeg" alt="figure1" />

<div align="center">
  <a href="https://arxiv.org/pdf/1409.4842" target="<sub>blank</sub>">
    Going deeper with convolutions
  </a>
</div>

## Abstract
GoogLeNet은 Inception 이라는 architecture를 제안하고 적용한 모델입니다. 이 구조의 주요 특징은 네트워크 내부의 계산 자원을 보다 효율적으로 활용할 수 있다는 점이라고 말합니다. 이러한 효율적인 구조를 이용해서 네트워크를 더욱 깊이 있게 설계할 수 있게 되었으며, 22개층으로 이루어진 이 네트워크는 분류와 탐지 모두에서 좋은 성능을 보였다고 설명합니다. 

## Introduction
지난 3년간 CNN이 지속적으로 발전되고 있다고 언급하고 있습니다. 특히 주목할만한 점은, 단순이 더 큰 데이터셋 그리고 더 큰 모델을 사용해서 개선이 된것이 아니라 개선된 architecture의 결과라는 부분이라고 설명합니다. 이 논문에서 제안하는 GoogLeNet은 Alexnet보다 parameter수는 12배가 적게 구성되었다는 점을 강조하고 있습니다. 이 논문에서는 Inception 이라는 architecture를 제안하고 있고 그 의의가 어떻다라는 점을 설명합니다.  

## Related Work
LeNet, AlexNet, VGG에 까지 CNN은 일반적인 구조를 가지고 있었다고 설명합니다. 여러개의 convolutional layer를 쌓고 그 뒤에 fully connected layer를 붙이는 방식이었고 최근까지 그 깊이를 늘리는 방향으로 연구가 진행되고 있다고 설명합니다. 원숭이 시각 피질의 신경과학 모델에서 영감을 받아 고정된 다양한 크기의 Gavor filter 를 이용한 연구도 이어졌습니다. 다양한 크기의 filter를 적용하는 이러한 구조에서 inception architecture는 이를 학습 가능한 parameter로 두었다는 점에서 그 차별점이 있다고 설명합니다. Network-in-Network 접근법도 연구되었습니다. 1 by 1 convolution layer의 적용은 차원 축소 모듈로서 사용되며 네트워크 깊이와 폭을 늘릴 수 있게 해준다고 설명합니다. 

## Motivation and High Level Considerations
neural network의 성능을 향상시키는 가장 직관적인 방법은 네트워크의 크기를 키우는것이라 주장합니다. 깊이를 늘리거나, 채널을 늘리는 방향으로 네트워크를 키울 수 있다 말합니다. 이러한 방향에는 단점이 존재하는데, 첫째, 매개변수가 증가하고 이는 overfitting의 문제에 취약해지게 된다고 설명합니다. 둘째, 의미없이 늘린 architecture는 비효율적인 계산을 하게 될 수 있다고 설명합니다. 이 문제들을 해결하기 위해선 완전 연결 네트워크에서 희소 연결 네트워크로 전환해야한다라고 주장하고 있습니다. 이러한 단점을 해결하기 위해 Inception architecture의 개발이 시작되었다고 얘기합니다.   

## Architectural Details
Inception architecture 에서는 1by1 3by3 5by5 의 fiter를 적용한 convolution layer들을 활용한다고 합니다. 이때, 3by3 이나 5by5 kernel을 적용하는 과정에서 계산량이 크게 늘어나게 되는데 이에 앞서 1by1 convolution을 적용하여 차원축소를 하는것으로 이를 방지했다고 설명합니다. 이러한 설계의 장점은 계산량을 늘리지 않으면서도 다양한 크기로 시각정보를 처리한 후 이를 집계하여 다음단계로 내보낼 수 있다는점 이라고 합니다.

## GoogLeNet
network의 수용크기는 224by224 라고 합니다. RGB 채널의 평균을 빼는 전처리를 수행한다고 합니다. 네트워크는 parameter가 있는 layer만 세면 22층, 풀링 레이어까지 포함하면 27층으로 구성하였다고 합니다. 중간 레이어에 보조 분류기(auxiliary classifier)를 추가하여 네트워크 하위 단계에서 더 구별되는 특징을 학습할 수 있도록 하고 역전파되는 그레디언트 신호를 강화하였다고 설명합니다. 

## Training Methodolgy
SGD optimizer을, 0.9 momentum 으로 사용하였다고 합니다. 또한 learning rate를 8 epoch마다 4%씩 증가시키며 학습시켰다고 합니다.  

## ILSVRC 2014 Classification Challenge Setup and Results

## ILSVRC 2014 Detection Challenge Setup and Results

## Conclusions
이 연구로부터 깊이는 늘리되 더 작은 크기를 갖는 모델을 효율적으로 설계할 수 있다는 것을 밝혀냈다고 주장합니다.  
