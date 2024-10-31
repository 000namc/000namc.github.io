---
title: "(Transformer) Attention Is All You Need 리뷰"
date: 2024-10-31
layout: post
categories: 
- AI-Research
tags: 
- nlp
---

-   상위포스트 : nlp분야 논문리뷰 및 구현
-   논문 : <https://arxiv.org/pdf/1706.03762>
-   구현 : <https://github.com/000namc/paper-implementations/tree/main/vision>

## (Transformer) Attention Is All You Need
![img](https://000namc.xyz/nginx/blog/transformer/figure1.jpeg)

### Abstract
Transformer는 attention mechanism만을 이용한 simple한 모델이라고 설명합니다. 이는 이떄까지의 주된 sequencial 모델들이 CNN 혹은 RNN에 기반을 둔것 그리고 encoder와 decoder를 attention mechanism으로 연결한 과거 연구와 다릅니다. 두가지 기계 번역 테스크에서 이 모델의 성능이 우수하며 병렬화가 가능하고 훈련에 필요한 시간이 적다는것을 확인하였다고 합니다. WMT-2014 영어-프랑스어 번역작업에서 state of the art인 성능을 보였으며, 영어 구문 분석 작업에도 성공적으로 적용되었다고 합니다.

### Introduction
RNN, LSTM, GRN등이 언어 모델링과 기계 번역에서 활발히 연구되어 왔습니다. 이러한 RNN 모델들은 입력 및 출력 sequence의 위치에 따라 계산되는 식이 달라지는데, 예를들어 $h_t$ 를 계산할때 $h_{t-1}$ 에 대한 함수로써 계산하게 됩니다. 이러한 설계가 training 과정에서의 병렬화를 방해하고, 긴 sequnce의 입력 데이터에서 메모리 제약으로 인한 문제를 야기한다고 합니다. 

이 논문에서는 attention mechanism과 RNN의 구조를 함께 활용했던 연구들과 달리, 입력과 출력간의 전역적 의존성을 모델링하기 위해 attention mechanism만을 활용하는 Transformer를 제안한다고 합니다. 

### Model Architecture
encoder는 input sequence $x = (x_1, \cdots, x_n)$ 을 입력으로 하여 continuous representations $(z = (z_1, \cdots, z_n))$ 을 추출해 내는 구조를 갖고, decoder는 $z$ 를 입력으로 하여 최종적으로 fully connected layer를 거쳐 output sequence $y = (y_1,\cdots, y_m)$ 를 추출해내는 구조를 갖는다고 합니다.

![img](https://000namc.xyz/nginx/blog/transformer/figure2.jpeg)

#### Encoder and Decoder Stacks
-   Encoder는 6개의 encoder layer를 쌓아 구성합니다. 각 encoder layer는 두개의 sub layer, multi-head self-attention layer와 linear layer로 구성되며 각각 layer를 normalization을 하는데에 residual connection을 적용합니다.
-   Decoder도 6개의 decoder layer를 쌓아 구성합니다. encoder layer와 비슷하게 구성하되 세개의 sub layer로 이루어지는데, 2개의multi-head self-attention layer와 linear layer로 구성되며 중간의 self-attention layer는 첫번째 self-attention의 결과 sequence와 Encoder의 결과 sequence를 입력으로 하는 구조를 갖는다고 합니다.
    
    {% highlight nil %}
    Encoder = concat(
        encoder_layer,
        encoder_layer,
        encoder_layer,
        encoder_layer,
        encoder_layer,
        encoder_layer
    )
    
    encoder_layer =  (
        .multi-head_self-attention()
        .norm_with_residual()
        .linear()
        .norm_with_residual()
    )
    {% endhighlight %}
    
    {% highlight nil %}
    Decoder = concat(
        decoder_layer,
        decoder_layer,
        decoder_layer,
        decoder_layer,
        decoder_layer,
        decoder_layer
    )
    
    decoder_layer =  (
        .multi-head_self-attention()
        .norm_with_residual()
        .multi-head_self-attention(z, )
        .norm_with_residual()
        .linear()
        .norm_with_residual()
    )
    {% endhighlight %}

#### Attention
Attention 의 가장 큰 구성요소는 Query, Key, Value로 이루어진 pair입니다. 최종적으로 사용하는 Attention의 architecture는 multi-head Attention인데, 이는 Self Attention을 몇겹 쌓아 구성합니다.

![img](https://000namc.xyz/nginx/blog/transformer/figure3.jpeg)

-   pair (Query, Key, Value)는 각각 입력sequence에 학습가능한 가중치 행렬을 곱하여 얻어낸 linear projection입니다.
-   Self Attention 은 다음과 같은 수식으로 계산합니다. 의미를 생각해보자면, 결국 V에 담긴 정보에 softmax를 거친 가중치 행렬이 곱해져 나오는 결과를 얻어내는 것인데, 어떻게 V를 활용할지를 Q와K의 정보에서 추출해낸다 라고 보면 되겠습니다.

$$\text{Attention}(Q, K, V) = \text{softmax}(\frac{QK^T}{\sqrt{d_k}})V$$

-   Multi-Head Attention는 위 Self Attention에 나오는 정보를 여러개 축척하여 구성합니다. 여기서 W는 각 self attention이 각 다른 차원의 정보력을 갖을 수 있도록 한 설계라고 보면 되겠습니다. 이렇게 학습가능한 parameter를 이용하여 V라는 value에서 어떤 정보들을 추출하여 사용할지를 얻어내는 구조가 됩니다.

$$
\text{MultiHead}(Q,K,V) = \text{Concat}(\text{head}_1, \cdots, \text{head}_h) W^O \\
\text{where, } \text{head}_i = \text{Attention}(QW^Q_i,KW^K_i,VW^V_i)
$$

### Why Self-Attention
to be written

### Training
#### Training Data and Batching

#### Hardware and Schedule
8개의 P100 GPU를 사용하였고, 가장 큰 모델의 경우 학습하는데 총 3.5일이 소요되었다고 합니다.

#### Optimizer
Adam optimizer를 사용하였다고 합니다. (with $\beta_1 = 0.9, \beta_2 = 0.98$ and $\epsilon = 10^{-9}$)

#### Regularization
Residual Dropout과 Label Smoothing를 활용하였다고 설명합니다. 

### Results
to be written

### Conclusion
이 논문에서는 attention만을 기반으로한 최초의 sequence model Transformer가 소개되었습니다. 여러 도메인에서 state of the art인 성과를 거둔만큼 더 의미가 있겠습니다. 이러한 Transformer를 더 다양한 문제로 확장하고 또한 이미지, 오디오, 비디오와 같은 영역으로의 확장도 연구해 나갈 예정이라고 합니다. 
