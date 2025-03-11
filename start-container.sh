#!/bin/bash

echo "GCP 개발 환경 초기화 중..."

# 키 파일 확인
if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
  echo "키 파일 확인됨: $GOOGLE_APPLICATION_CREDENTIALS"

  # gcloud CLI 인증 수행
  echo "GCP 서비스 계정 인증 중..."
  if gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS; then
    echo "서비스 계정 인증 완료"
    
    # 클라이언트 이메일 출력
    CLIENT_EMAIL=$(cat $GOOGLE_APPLICATION_CREDENTIALS | grep client_email | cut -d '"' -f 4)
    echo "서비스 계정 : $CLIENT_EMAIL"
    GCP_PROJECT_ID=$(cat $GOOGLE_APPLICATION_CREDENTIALS | grep project_id | cut -d '"' -f 4)
  
    # GCP 프로젝트 설정
    if [ -n "$GCP_PROJECT_ID" ]; then
      echo "GCP 프로젝트 설정: $GCP_PROJECT_ID"
      gcloud config set project "$GCP_PROJECT_ID"
      echo "프로젝트 $GCP_PROJECT_ID 활성 완료."
      echo "이 프로젝트가 서비스 계정에 연결되어 있다면 할당량 프로젝트로 적용 됩니다."
  
    else
      echo "경고: GCP_PROJECT_ID 환경 변수가 설정되지 않았습니다."
    fi
  else
    echo "서비스 계정 인증 실패"
  fi
else
  echo "오류: 키 파일이 없습니다. 환경 변수 KEYFILE_NAME이 올바르게 설정되었는지 확인하세요."
fi

# 코드 서버 실행
echo "코드 서버 시작 중..."
code-server --bind-addr 0.0.0.0:8080 --user-data-dir /workspace/.vscode-server --auth none /workspace