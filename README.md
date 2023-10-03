<h1 align="center">🚑<strong>findER</strong>🚑</h1>

<div align="center">
  <strong>실시간 응급실 정보 제공 서비스</strong>
</div>

<div align="center">
  <h3>
    <a href="https://github.com/malalove/findER-backend">
      💽 Backend
    </a>
    <span> | </span>
    <a href="https://malalove.notion.site/API-2f5e86d852ca4f73b2e66c21b8a31e3d?pvs=4">
      📜 REST API 명세서
    </a>
  </h3>
</div>
<br>

## 🔖 목차

- [개발배경 및 목적](https://github.com/gretea5/findER-frontend#-%EA%B0%9C%EB%B0%9C%EB%B0%B0%EA%B2%BD-%EB%B0%8F-%EB%AA%A9%EC%A0%81)
- [개발환경 및 개발언어](https://github.com/gretea5/findER-frontend#-%EA%B0%9C%EB%B0%9C%ED%99%98%EA%B2%BD-%EB%B0%8F-%EA%B0%9C%EB%B0%9C%EC%96%B8%EC%96%B4)
- [시스템 구성 및 아키텍처](https://github.com/gretea5/findER-frontend#-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EA%B5%AC%EC%84%B1-%EB%B0%8F-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98)
- [프로젝트 주요 기능](https://github.com/gretea5/findER-frontend#-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%A3%BC%EC%9A%94-%EA%B8%B0%EB%8A%A5)
- [팀 정보](https://github.com/gretea5/findER-frontend#-%ED%8C%80-%EC%A0%95%EB%B3%B4)
- [시연영상](https://github.com/gretea5/findER-frontend#%EF%B8%8F-%EC%8B%9C%EC%97%B0%EC%98%81%EC%83%81)


## 📍 개발배경 및 목적
지난 5월 발생한 교통사고로 크게 다친 70대 남성이 당시 병상이 부족하다는 이유로 대형병원 11곳에서 이송을 거부당해 약 2시간 만에 구급차 안에서 사망한 사례가 있었습니다. 
또한 지난 3월 대구에서는 한 10대 환자가 구급차를 타고 2시간 30분가량 떠돌다 사망하였습니다. 이렇게 응급실에 대한 부족한 정보로 인해 환자들이 사망하는 사회적 문제를 해결하고자
저희 팀은 실시간 응급실 정보 제공 서비스 애플리케이션을 개발하게 되었습니다. 응급실(Emergency Room)을 찾는(find) 매개체라는 의미에서 ‘findER’라는 이름을 선정하였습니다.
<br>
<br>
해당 앱을 사용하는 사용자는 응급 상황 발생 시 자신의 위치를 기준으로 가까운 순서대로 응급실의 위치, 예상 도착 시간, 최적 경로 등을 확인할 수 있습니다.
또한 각 응급실의 잔여 병상 수를 실시간으로 확인 가능함과 동시에 현재 시각으로부터 2시간 동안의 병상 이용 가능 시간 비율 및 병상 수 변동 추이 그래프를 제공하여 
사용자가 최적의 응급실을 선택하는 데 있어 도움을 줄 수 있습니다.

## 📌 개발환경 및 개발언어
<div>
<table>
   <tr>
      <td colspan="4" align="center">
        <strong>개발환경</strong>
      </td>
      <td colspan="4">
        <img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=macOS&logoColor=white"> 
        <img src="https://img.shields.io/badge/Amazon EC2-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white"/>
      </td>
   </tr>
   <tr>
      <td colspan="4" align="center">
        <strong>개발언어</strong>
      </td>
      <td colspan="4">
        <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=Dart&logoColor=white"> 
        <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter&logoColor=white"> 
        <img src="https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=java&logoColor=white"> 
        <img src="https://img.shields.io/badge/Spring Boot-6DB33F?style=for-the-badge&logo=Spring Boot&logoColor=white"> 
      </td>
   </tr>
</table>
</div>

## 🖻 시스템 구성 및 아키텍처
<img width="895" alt="image" src="https://github.com/malalove/findER-backend/assets/120379834/9b0f0a2c-8605-4a19-be7a-4d76d3c5e4df">

## ✨ 프로젝트 주요 기능

- 응급실 정보 제공 (위치, 전화번호 外 CT & MRI 촬영 가능 여부 등)
- 응급실 잔여 병상 수 실시간 제공 (1분 간격 갱신)
- 카카오 맵 API를 통한 사용자 현재 위치 기준 가까운 응급실 목록 및 최적 경로 제공
- 카카오 모빌리티 API를 통한 응급실 예상 도착 시간 및 이동 거리 제공
- 최근 2시간 동안의 병상 이용 가능 시간 비율 그래프 제공
- 최근 2시간 동안의 병상 수 변동 추이 그래프 제공 (15분 간격)
- 사용자 문진표 작성 기능 제공
- 사용자 간 문진표 연동을 통한 문진표 상호 동기화 기능 제공


## 👩‍👩‍👧‍👦 팀 정보

<div sytle="overflow:hidden;">
<table>
   <tr>
      <td colspan="2" align="center"><strong>Front-End Developer</strong></td>
      <td colspan="2" align="center"><strong>Back-End Developer</strong></td>
   </tr>
  <tr>
    <td align="center">
    <a href="https://github.com/gretea5"><img src="https://avatars.githubusercontent.com/u/120379834?v=4" width="150px;" alt="박장훈"/><br /><sub><b>박장훈</b></sub></a><br />
    </td>
     <td align="center">
        <a href="https://github.com/LapinMin"><img src="https://avatars.githubusercontent.com/u/130971355?v=4" width="150px" alt="민건희"/><br /><sub><b>민건희</b></sub></a>
     </td>
     <td align="center">
        <a href="https://github.com/wingunkh"><img src="https://avatars.githubusercontent.com/u/58140360?v=4" width="150px" alt="김현근"/><br /><sub><b>김현근(팀장)</b></sub></a>
     </td>
     <td align="center">
        <a href="https://github.com/fkgnssla"><img src="https://avatars.githubusercontent.com/u/92067099?v=4" width="150px" alt="김형민"/><br /><sub><b>김형민</b></sub></a>
     </td>
  <tr>
</table>
</div>

## 📽️ 시연영상
[시연영상 바로가기 ✈️](https://youtu.be/m4FCF3DETNg)
