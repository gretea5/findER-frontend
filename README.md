<h1 align="center">🚑<strong> findER </strong>🚑</h1>

<div align="center">
  <strong>2023년 제 17회 공개SW 개발자대회</strong>
  <br><br>
  <em>실시간 응급실 정보 제공 서비스 애플리케이션, findER</em>
  <br><br>
  <em>written by gretea5 & wingunkh</em>
</div>

<div align="center">
    <h3>
    <a href="https://malalove.notion.site/API-2f5e86d852ca4f73b2e66c21b8a31e3d?pvs=4">
      📜 REST API 명세서
    </a>
    <span> | </span>
    <a href="https://github.com/malalove/findER-frontend">
      🖼️ Frontend
    </a>
    <span> | </span>
    <a href="https://github.com/malalove/findER-backend">
      💽 Backend
    </a>
    <span> | </span>
    <a href="https://github.com/malalove/findER-tracker">
      🏭 Tracker
    </a>
  </h3>
</div>

## 🔖 목차
- 개발배경 및 목적
- 주요 기능
- 기술 스택
- 시스템 구조도
- 팀원 및 담당 파트
- 시연 영상

## 📍 개발 배경 및 목적
'응급실 뺑뺑이'란 응급 환자가 이송 병원을 정하지 못해 다른 병원에 재이송되는 현상을 의미합니다. <br><br>
이러한 현상으로 인해 환자가 사망에 이르는 사회적 문제가 나날이 대두되고 있습니다. <br><br>
저희 팀은 '응급실에 대한 정보 부족'이 해결될 수 있다면 이러한 문제가 줄어들 것으로 판단하여 <br>
실시간 응급실 정보 제공 서비스 애플리케이션을 개발하게 되었습니다. <br><br>
애플리케이션의 이름은 응급실(Emergency Room)을 찾는(find) 매개체라는 의미에서 ‘findER’로 선정하였습니다. <br><br>
해당 애플리케이션을 사용하는 사용자는 응급 상황 발생 시 자신의 위치를 기준으로 가까운 순서대로 <br>
응급실의 위치, 예상 도착 시간, 최적 경로 등을 확인할 수 있습니다. <br><br>
또한 각 응급실의 잔여 병상 수를 실시간으로 확인 가능함과 동시에 현재 시각으로부터 2시간 동안의<br>
병상 이용 가능 시간 비율 및 병상 수 변동 추이 그래프를 제공하여 사용자가 최적의 응급실을 선택하는 데 있어 도움을 줄 수 있습니다.

## 🎯 주요 기능
> ### 응급실 정보 제공 (위치, 전화번호 外 CT & MRI 촬영 가능 여부 등)
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <div>
  <img width="325" height="720" alt="" src=https://github.com/wingunkh/tmp/assets/58140360/4a89e085-ea65-4fc6-b2da-df18a5092f94>
  <br><br>
  </div>
</details>

> ### 응급실 잔여 병상 수 실시간 제공 (1분 간격 갱신)
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" 
    height="720" alt="" 
    src=https://github.com/wingunkh/tmp/assets/58140360/d242fac0-876a-4f7f-8dd6-e0db0d470b28>
    <br><br>
  </div>
</details>

> ### 카카오 맵 API를 통한 사용자 현재 위치 기준 가까운 응급실 목록 및 최적 경로 제공
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" 
    height="720" 
    alt=""
    src=https://github.com/wingunkh/tmp/assets/58140360/41d36817-6757-4e14-9091-917242507e35>
  <br><br>
  </div>
</details>


> ### 카카오 모빌리티 API를 통한 응급실 예상 도착 시간 및 이동 거리 제공
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" 
    height="720" 
    alt=""
    src=https://github.com/wingunkh/tmp/assets/58140360/0d8a2ef1-a26d-4c90-b38b-8644682774e5>
    <br><br>
  </div>
</details>

> ### 최근 2시간 동안의 병상 이용 가능 시간 비율 그래프 제공
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" 
    height="720" 
    alt=""
    src=https://github.com/wingunkh/tmp/assets/58140360/5874eaba-37ee-4988-90c6-6cfd5fd5093d>
  <br><br>
</details>

> ### 최근 2시간 동안의 병상 수 변동 추이 그래프 제공 (15분 간격)
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" 
    height="720" 
    alt=""
    src=https://github.com/wingunkh/tmp/assets/58140360/cf5eae1f-8869-4eea-9bdf-d5b6b39ccae5>
  <br><br>
</details>


> ### 사용자 문진표 작성 기능 제공
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" 
    height="720" 
    alt=""
    src=https://github.com/wingunkh/tmp/assets/58140360/602255af-7424-4a5c-a9c3-10e7a25f8b13>
  <br><br>
</details>

> ### 사용자 간 문진표 연동을 통한 문진표 상호 동기화 기능 제공
<details>
  <summary><b>화면 보기</b></summary>
  <br>
  <img 
    width="325" height="720" alt=""
  src=https://github.com/wingunkh/tmp/assets/58140360/bcae936e-35a6-4261-960c-b8002831d778>
  <br><br>
</details>



## 📌 기술 스택
<div>
    <table>
        <tr>
            <td colspan="2" align="center">
                Language
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=Dart&logoColor=white"> 
                <img src="https://img.shields.io/badge/java-007396?style=for-the-badge&logo=openjdk&logoColor=white">
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                Library & Framework
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter&logoColor=white">
                <img src="https://img.shields.io/badge/spring boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">
                <img src="https://img.shields.io/badge/spring security-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white">
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                API
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/DATA.go.kr-00529B?style=for-the-badge&logo=D&logoColor=white"> 
                <img src="https://img.shields.io/badge/Kakao Map Api-FFCD00?style=for-the-badge&logo=kakao&logoColor=black"> 
                <img src="https://img.shields.io/badge/Kakao Mobility-FFCD00?style=for-the-badge&logo=kakao&logoColor=black"> 
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                Server
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/amazon ec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white"> 
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                Database
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/docker-2496ED?style=for-the-badge&logo=docker&logoColor=white">
                <img src="https://img.shields.io/badge/oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white">
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                Tool
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/intellij idea-000000?style=for-the-badge&logo=intellijidea&logoColor=white">
                <img src="https://img.shields.io/badge/visual studio code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white">
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                etc.
            </td>
            <td colspan="4">
                <img src="https://img.shields.io/badge/postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white">
                <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white">
            </td>
        </tr>
    </table>
</div>

## 🖻 시스템 구조도
<img width="895" alt="image" src="https://github.com/gretea5/findER-frontend/assets/120379834/f94a9594-c195-48fc-bfc4-a8fd02e64f2d">

> 백엔드 애플리케이션 : 모바일 애플리케이션의 백엔드 애플리케이션 <br>
> 트래커 애플리케이션 : 1분 간격으로 전국 400여 개의 응급실의 실시간 병상 수를 갱신하기 위한 별도의 애플리케이션

## 👩‍👩‍👧‍👦 팀원 및 담당 파트
<div sytle="overflow:hidden;">
<table>
   <tr>
      <td colspan="2" align="center"><strong>Front-End Developer</strong></td>
      <td colspan="2" align="center"><strong>Back-End Developer</strong></td>
   </tr>
  <tr>
    <td align="center">
        <a href="https://github.com/gretea5"><img src="https://avatars.githubusercontent.com/u/120379834?v=4" width="150px;" alt="박장훈"/><br/><sub><b>박장훈</b></sub></a>
    </td>
     <td align="center">
        <a href="https://github.com/LapinMin"><img src="https://avatars.githubusercontent.com/u/130971355?v=4" width="150px" alt="민건희"/><br/><sub><b>민건희</b></sub></a>
     </td>
     <td align="center">
        <a href="https://github.com/wingunkh"><img src="https://avatars.githubusercontent.com/u/58140360?v=4" width="150px" alt="김현근"/><br/><sub><b>김현근(팀장)</b></sub></a>
     </td>
     <td align="center">
        <a href="https://github.com/fkgnssla"><img src="https://avatars.githubusercontent.com/u/92067099?v=4" width="150px" alt="김형민"/><br/><sub><b>김형민</b></sub></a>
     </td>
  <tr>
</table>
</div>

> 박장훈 : Flutter 사용 모바일 애플리케이션 공동 개발 / Kakao Map API 사용 위치 기반 서비스 개발 <br>
> 민건희 : Flutter 사용 모바일 애플리케이션 공동 개발 <br>
> 김현근 : Spring Boot 사용 백엔드 애플리케이션 공동 개발 / Spring Boot 사용 트래커 애플리케이션 개발 <br>
> 김형민 : Spring Boot 사용 백엔드 애플리케이션 공동 개발 / Spring Security 사용 토큰 기반 로그인 체계 확립 <br>

## 📽️ 시연 영상
[시연 영상 바로가기 ✈️](https://youtu.be/m4FCF3DETNg)
