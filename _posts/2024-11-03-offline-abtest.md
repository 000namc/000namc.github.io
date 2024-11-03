---
title: "Offline A/B testing for Recommender Systems 수식 정리"
date: 2024-11-03
layout: post
categories: 
- AI-Research
tags: 
- recommendation
---


## Intro
이 논문은 Criteo 에서 실제 서비스에 활용중이라고 하는 추천 도메인에서의 offline a/b test 기법에 관한 논문입니다. 추천시스템은 그 구조상 positional bias의 문제로, 과거 추천 결과 로그를 이용하여 평가하는데에 문제가 있다고 알려져 잇습니다. 이 논문은 이러한 bias를 해결할 수 있으며 충분히 과거 데이터로부터 offline a/b test를 할 수 있음을 밝히는 연구가 되겠습니다. (특히 개인화 추천에서의 방법론)

이 논문에 대한 이해는 직전 회사에서 근무할때에 한번 정리를 했었는데요. 버즈니에서 추천을 메인으로 맞지 않았지만 동료 리서처로부터 논문을 한번 읽어봐줄 수 있냐 요청을 받았는데, 논문의 전체적인 구조를 훝어봤을때 논문에 나오는 노테이션 정도만 관련 연구들을 리뷰하며 이해하고 나면 충분히 이해하고 정리할 수 있겠다 싶어 읽어보게 되었습니다. 중간에 중의적으로 해석될 수 있는 영어표현이 있어 논문 저자(Alexandre Gilotte)에게 직접 메일을 보내고 확인하는 과정을 거쳐 어떤 의미를 갖는 논문인지 또 수식이 어떻게 정리되는건지 그리고 실제 서비스에 적용하려면 어떻게 데이터를 준비해야하는지 정리할 수 있었습니다. 

## Abstract
![img](https://000namc.xyz/nginx/blog/offline-abtest/figure1.jpeg)

## 기본 notation
-   Let $x$ denote the contextual features
-   Let $a$ denote any product of top-K
-   Let $r = r(a, x)$ denote a reward that could be the number of clicks or the generated revenue.
-   We will represent random variables with capital letters such as $Y$ and realization of random variables with lower-case letters such as $y$
-   A policy $\pi$ or $\pi(A∣X = x)$ is a probability distribution over $A$ for a given $x$, where $A$ represents list of top-K products.
-   Let $\pi_p, \pi_t$ denote product policy and test policy, respectively.
-   To compare these two policy, we estimate the average difference of value $Δ$

## 핵심 수식
-   We know:

$$
Δ(\pi_p, \pi_t) = E_{\pi_t} [R] − E_{\pi_p} [R],
$$

where $R = R(A, X )$ is a random variable which represents reward, and $E_\pi [R] = ∫∫ r(a, x)\pi(a, x)p(x)dadx$

-   It follows:

$$
E_{\pi_t} [R] = \int \int r(a,x) \pi_t (a,x)p(x)dadx
= \int \int r(a,x) \frac{\pi_t(a,x)da}{\pi_p(a,x)da} \pi_p(a,x)p(x)dadx
= E_{\pi_p} [R \frac{\pi_t}{\pi_p} ]
$$

-   which leads to the following Monte-Carlo estimator:

$$
F_n = \frac{1}{n} \sum_{(x,a) \in S_n} \frac{\pi_t(a,x)}{\pi_p(a,x)}r
$$

-   by weak law of large numbers, it follows $F_n$ is an unbiased estimator of $E_{\pi_t} [R]$

## 의미
저 스스로도 추천 도메인에 전문가가 아니기 때문에 이해가 틀릴 수 있으나 지금 이해하고 있는 선에서 정리해보겠습니다. 먼저 추천 모델은 policy function $\pi$ (a probability distribution over $A$ for a given  $x$)의 형태로 활용이 됩니다. $\pi(a,x)$ 는 contextual feature $x$ 를 참고하여 tok-K 의 추천목록을 그 순서로 보여줬을 확률을 의미합니다. 이러한 $\pi$ 는 모델링하기 어려워 보일 수 있으나 단순하게 일반적인 스코어링 함수 $f(x)$와 Plackett-Luce model로 부터 자연스럽게 얻어 낼 수 있습니다(Criteo에서도 역시 이렇게 구성해서 사용한다고 확인받았습니다.). 이런식으로 구성하면 직접 설계한 상품 스코어링 함수 $f(x)$에 dependent한 top-K 상품리스트의 샘플링을 할 수 있고 이는 서비스 단계에서 더 다양한 상품이 노출 될 수 있는 방식으로 동작하게 됩니다. 아무쪼록 이러한 policy function으로써 추천모델을 구성하였다면 이제 policy function을 평가할 수 있어야겠습니다. 그 성능 지표가 $E_\pi [R]$ 입니다. 

위 핵심 수식의 의미를 그대로 설명하자면, """위에 잘 정리된 대로, $r, R$ 은 각각 realization, random variable 로써 정의된 리워드 입니다. 보통 추천 모델에서 활용하는 지표인 ctr 을 $R$ 이라 보면 되겠습니다. 신규 모델에 대해서 이 R에 대한 기대 리워드 $E_{\pi_t} [R]$ 를 계산할 수 있겠느냐가 핵심 포인트 인데, 위 식 정리에 따르면 $E_{\pi_t} [R]$ 는 $E_{\pi_p} [R\frac{\pi_t}{\pi_p}]$ 와 같고 이는 weak law of large numbers에 의해서 과거 로그에 대한 어떤 계산인 $F_n$ 으로 unbiased하게 추정할 수 있다.""" 라고 정리할 수 있겠습니다. 

결국 $n$ 개의 과거 로그($S_n$)를 이용해서 신규 policy의 기대 리워드를 얻을 수 있게 되겠습니다. 저희가 일반적으로 생각하는것과 다른점은 과거 로그로부터 리워드를 그대로 평균내서 평가하는것이 아니라, 과거 policy 대비 신규 policy의 점수를 리워드에 곱한 후 평균을 낸다는게 다르겠습니다. 결과적으로 이렇게 과거 로그를 기반으로 추천 시스템을 unbiased하게 평가하기 위해서는 추천을 서비스할때, 모델의 상품에 대한 예측 점수를 모두 기록해야한다는 것을 알 수 있겠습니다.   

## Reference
-   Gilotte, Alexandre, et al. "Offline a/b testing for recommender systems." Proceedings of the Eleventh ACM International Conference on Web Search and Data Mining. 2018.
-   <https://statisticaloddsandends.wordpress.com/2024/04/24/what-is-the-plackett-luce-model/>
