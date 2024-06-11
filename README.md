## 📱보이스피싱 탐지 어플리케이션 | SSGcam

### 🔊 소개

**스윽캠**(**SSGcam**)은 **실시간 보이스피싱 탐지 어플리케이션**입니다. 실제 통화 내용을 실시간으로 분석하여 보이스피싱 및 딥보이스 탐지 기능을 제공합니다. AI를 활용하여 의심스러운 패턴을 식별하고 사용자에게 경고합니다. 자연어 처리(NLP) 기술과 딥러닝 모델을 사용하여 높은 정확도의 탐지 기능을 구현했습니다.

<img src="https://github.com/bean-i/SSGcam/assets/86592841/35e7be72-f66e-49c5-bf02-843744549c5f" style="width: 100%;">

## 💬 목차
1. [💡 개요](#1---개요)
2. [✅ 주요 기능](#2---주요-기능)
   - [회원가입 및 로그인](#-회원가입-및-로그인)
   - [보이스피싱 탐지 및 알람](#-보이스피싱-탐지-및-알람)
   - [딥보이스 탐지 및 알람](#-딥보이스-탐지-및-알람)
   - [탐지 기록 다시 듣기](#-탐지-기록-다시-듣기)
   - [챗봇](#-챗봇)
   - [전화번호 검색](#-전화번호-검색)
3. [⏯️ 실제 시연 영상](#3---시연-영상)
4. [💻 기술 스택](#4---기술-스택)
5. [⚙️ 아키텍처](#5---아키텍처)
   - [시스템 아키텍처](#시스템-아키텍처)
   - [인포메이션 아키텍처](#인포메이션-아키텍처)
6. [🦾 모델](#6---모델)
   - [보이스피싱 탐지](#-보이스피싱-탐지)
   - [딥보이스 탐지](#-딥보이스-탐지)
7. [👥👥 팀원](#7---팀원)

## 1 ) 💡 개요
- 프로젝트 이름: 보이스피싱 탐지 어플리케이션 | SSGcam
- 프로젝트 기간: 2024.03 ~ 2024.06

(본 프로젝트는 2024-1 세종대학교 캡스톤 디자인(산학 협력 프로젝트)에 기반을 두었습니다.)

<table style="border: none; width: 100%;">
  <tr style="border: none;">
    <td style="border: none; width: 50%;"><img src="https://github.com/bean-i/SSGcam/assets/86592841/62336015-7a4f-4ce8-953d-188073fc5084" style="width: 100%;"></td>
    <td style="border: none; width: 50%;"><img src="https://github.com/bean-i/SSGcam/assets/86592841/ae51801c-3b5d-4fac-ae76-7b5819321204" style="width: 100%;"></td>
  </tr>
</table>

스윽캠은 매년 늘어나는 보이스피싱과 고도화되는 보이스피싱 수법에 대응하기 위해 만들어졌으며, AI 기술을 활용하여 실시간 보이스피싱 및 딥보이스 탐지 기능을 제공합니다. 사용자는 스윽캠을 통해 다양한 보이스피싱으로부터 보호받을 수 있습니다.

## 2 ) ✅ 주요 기능
### 🔐 회원가입 및 로그인
- **회원가입**: 사용자는 아이디와 비밀번호를 통해 계정을 생성할 수 있습니다. 이때, 보호자 연락처를 입력받아 추후 보호자 알림에 사용합니다.
- **로그인**: 생성된 계정을 통해 어플리케이션에 로그인할 수 있습니다.
- **권한 허용**: 어플리케이션 사용에 필요한 마이크와 알림 등의 권한을 허용합니다.
  
### 🚨 보이스피싱 탐지 및 알람
실제 전화 통화 중 상대방의 **최초 4문장**을 받아 Speech To Text를 사용하여 텍스트로 변환 후, AI 서버에 넘겨 확률을 계산합니다. 이후, 보이스피싱이라고 판단하면 화면에 알림(배너, 소리, 진동)을 띄웁니다.

### 🚨 딥보이스 탐지 및 알람
실세 전화 통화 중 **최초 10초**를 기준으로 wav파일로 녹음하여 AI 서버에 넘겨 확률을 계산합니다. 이후, 딥보이스라고 판단하면 화면에 알림(배너, 소리, 진동)을 띄웁니다.

### 🎧 탐지 기록 다시 듣기
보이스피싱으로 탐지한 기록은 자동으로 어플리케이션의 탐지 기록 화면에 저장되어 언제든지 다시 확인할 수 있습니다. **전체 통화 내용 음성**을 다시 들을 수 있고, 피해 사례를 등록할 수 있습니다. (피해 사례 등록 시, 다른 사람이 검색할 수 있습니다.)

### 💭 챗봇
사용자가 원하는 정보를 보다 빠르게 제공하기 위해, 공통 질문을 미리 만들어 제공하였습니다.
- 보이스피싱 대처 방안
- 계좌 지급 정지 신청 방법
- 명의 도용 휴대전화 개설 조회
- 피해금 환급 신청 방법
  
과 같은 질문이 이에 해당합니다. 이외 궁금한 내용은 챗봇에게 직접 타이핑하여 질문하여 답변 받을 수 있도록 하였습니다.

### 🔎 전화번호 검색
모르는 전화번호로 전화가 올 때, 스윽캠에서 빠르게 전화번호를 검색할 수 있습니다. 전화번호에 해당하는 검색 결과(보이스피싱 유형)을 반환하고 만약 검색 결과가 없다면, 경찰청 홈페이지로 연결하여 추가 검색을 할 수 있도록 하였습니다.

## 3 ) ⏯️ 실제 시연 영상
<table>
  <tr>
    <th>🔐 회원가입 및 로그인</th>
    <th>🚨 실제 전화 시연</th>
    <th>📞 착신 전환</th>
  </tr>
  <tr>
    <td align="center">
      <img width="300px" src="https://github.com/bean-i/SSGcam/assets/86592841/f2dfa3ec-ed03-4b78-a17e-71002ae82257">
    </td>
    <td align="center">
      <img width="300px" src="https://github.com/bean-i/SSGcam/assets/86592841/4e171fc1-f328-4141-83b3-ee34857a9aa4">
    </td>
    <td align="center">
      <img width="300px" src="https://github.com/bean-i/SSGcam/assets/86592841/6c4a09b8-c209-4429-b4cc-6f19ced7edc0">
    </td>
  </tr>
  <tr>
    <th>💭 챗봇</th>
    <th>🔎 전화번호 검색</th>
    <th>🎧 탐지 기록</th>
  </tr>
  <tr>
    <td align="center">
      <img width="300px" src="https://github.com/bean-i/SSGcam/assets/86592841/1046cc18-0057-4ee0-a7a3-cb66f8f718dd">
    </td>
    <td align="center">
      <img width="300px" src="https://github.com/bean-i/SSGcam/assets/86592841/5880b85a-8100-4043-85cf-abf6037ff505">
    </td>
    <td align="center">
      <img width="300px" src="https://github.com/bean-i/SSGcam/assets/86592841/ff643242-df2a-41c5-87ee-124c5757a6b3">
    </td>
  </tr>
</table>


## 4 ) 💻 기술 스택
### 프론트
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-%23FA7343.svg?style=for-the-badge&logo=Swift&logoColor=white)

### 서버
![Node.js](https://img.shields.io/badge/Node.js-%2343853D.svg?style=for-the-badge&logo=Node.js&logoColor=white)

### DB
![MongoDB](https://img.shields.io/badge/MongoDB-%2347A248.svg?style=for-the-badge&logo=MongoDB&logoColor=white)

### AI
![TensorFlow](https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)
![Keras](https://img.shields.io/badge/Keras-%23D00000.svg?style=for-the-badge&logo=Keras&logoColor=white)


## 5 ) ⚙️ 아키텍처
### 시스템 아키텍처
<img src="https://github.com/bean-i/SSGcam/assets/86592841/a891a079-4348-4b62-ae51-c5cdb3013bd9" style="width: 80%;">

### 인포메이션 아키텍처
<img src="https://github.com/bean-i/SSGcam/assets/86592841/98036b9e-bf9d-4a7f-8c68-680d6336bb38" style="width: 80%;">

## 6 ) 🦾 모델
### 📌 보이스피싱 탐지
#### 🗒️ 데이터

보이스피싱 데이터 : 금융감독원 '그놈 목소리' + '바로 이 목소리'  

일반 데이터 : AI Hub 민원(콜센터) 질의-응답 데이터

#### 🦾 모델링
##### Process 1) 보이스피싱 유무 탐지

<img width="50%" alt="image" src="https://github.com/bean-i/SSGcam/assets/86592841/8c12ef0b-e392-47a5-969e-d23098d2a3cb">

##### Process 2) 보이스피싱 유형 탐지

<img width="50%" alt="image" src="https://github.com/bean-i/SSGcam/assets/86592841/8a57c596-4669-4378-87e7-87a7e559fec0">

### 📌 딥보이스 탐지
#### 🗒️ 데이터

딥보이스 데이터 : AI Hub 다화자 음성 합성 데이터

일반 보이스 데이터 : AI Hub 자유 대화 음성 데이터

#### 🦾 모델링

<img width="60%" alt="image" src="https://github.com/bean-i/SSGcam/assets/86592841/eaed6273-2223-4cd7-9a1c-6fa0b4e8e8ba">

## 7 ) 👥👥 팀원
<table>
  <tr>
    <th><strong>김강민</strong></th>
    <th><strong>김민정</strong></th>
    <th><strong>소유진</strong></th>
    <th><strong>이빈</strong></th>
  </tr>
  <tr>
    <td><img src="https://github.com/bean-i/SSGcam/assets/86592841/4883dd25-54d0-4fad-a534-5e9cbf951e6b" style="width: 100%;"></td>
    <td><img src="https://github.com/bean-i/SSGcam/assets/94227598/71bb6079-2d77-471f-bb5e-b8e262cb194a" style="width: 100%;"></td>
    <td><img src="https://github.com/bean-i/SSGcam/assets/86592841/35f284cd-f147-44d7-a1df-a3a81dfb8e10" style="width: 100%;"></td>
    <td><img src="https://github.com/bean-i/SSGcam/assets/86592841/280c1e8f-6e48-4cac-907e-ede6931ba4a9" style="width: 100%;"></td>
  </tr>
  <tr>
    <td><strong>🦾 AI</strong></td>
    <td><strong>📂 데이터베이스</strong><br><strong>⚙️ 백엔드</strong></td>
    <td><strong>📱 프론트엔드</strong><br><strong>⚙️ 백엔드</strong></td>
    <td><strong>📱 프론트엔드</strong><br><strong>⚙️ 백엔드</strong></td>
  </tr>
</table>
