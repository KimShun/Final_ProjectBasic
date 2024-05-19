# aniMall

2024 S/W Project Basic - Final Team Project

# common 파일 내에 존재하는 dart파일 설명.
## api_key.dart
  - 이용하는 서비스들의 api키들을 저장하여 사용하는 파일입니다.
  - api키는 여기에 저장하여, 불러오는 방식으로 사용하여 주십시오.

## app_text.dart
  - Text() 함수의 코드 길이를 최소화하기 위해 중복하여 사용할 디자인 부분을 미리 적용하였습니다.
  - 필수로 입력해야할 사항 ( title: {글 내용} / fontSize: {글씨크기} )
  - 선택으로 입력해야할 사랑 ( textDecoration: 글씨 꾸미기 / fontWeight: 글씨 두께 / textAlign: 글씨 정렬 / font: 폰트 / color: 색상)
    
###[입력예시]
```
AppText(
  # 필수 입력사항
  title: "테스트",
  fontSize: 15.0,
  # 선택 입력사항
  textDecoration: TextDecoration.underline, # 기본값 TextDecoration.none
  fontWeight: FontWeight.w500, # 기본값 FontWeight.bold
  textAlign: TextAlign.center, # 기본값 TextAlign.start
  font: "MalgunGothic", # 기본값 "Jua" - 주의! pubspec.yaml 폰트를 추가해야 사용가능!
  color: Colors.black, # 기본값 Colors.white
```

## color.dart
  - 자주 사용하는 색상코드를 저장시켜 편리하게 사용하기 위함.

## 추가 예정 - custom_circular.dart
  - 로딩 (동그라미) 부분 커스텀화 ( 자주 사용하는 부분이기에 제작 예정 )
