# Containerized GCP SDK environment

컴포즈 업 명령으로 간단히 GCP SDK 개발용 도커 컨테이너를 실행 할 수 있습니다.
- google/cloud-sdk:debian_component_based 도커 이미지를 베이스로 합니다.
   - BigQuery CLI 등 GCP 개발 구성 요소가 미리 설치된 환경입니다.
   - 구성 요소 전체는 [공식 문서](https://cloud.google.com/sdk/docs/downloads-docker?hl=ko#components_installed_in_each_tag)의 해당 이미지 칼럼을 참고 하세요.
- VS Code Server가 설치된 개발 환경 컨테이너입니다. 호스트 환경의 VS Code 기반 에디터로 원격 접속 할 수 있습니다.

## 필수 요구 사항

- Docker
- Docker Compose

## 설정 방법

1. GCP 서비스 계정 키 파일을 `gcp-config/keyfiles` 디렉토리에 저장하세요.
   - 서비스 계정 키 파일에는 프로젝트 ID를 포함한 모든 필요한 인증 정보가 포함되어 있습니다.
   - 별도의 프로젝트 ID 설정은 필요하지 않습니다.

2. 키파일 이름 설정:
   - 기본값은 `gcp-svc-acc.json`입니다.
   - 다른 이름의 키파일을 사용하려면 환경 변수 `KEYFILE_NAME`을 설정하세요.

3. VS Code Server 포트 설정:
   - 기본값은 `8080` 포트입니다.
   - 다른 포트를 사용하려면 환경 변수 `VSCODE_EXPOSE_PORT`를 설정하세요.

환경 변수 설정 방법:

**방법 1**: 커맨드 라인에서 환경 변수 설정:
```bash
export KEYFILE_NAME=your-keyfile-name.json
export VSCODE_EXPOSE_PORT=8888
docker-compose up -d
```

**방법 2**: `.env` 파일 생성:
```
# .env 파일 내용
KEYFILE_NAME=your-keyfile-name.json
VSCODE_EXPOSE_PORT=8888
```

## 사용 방법

1. 컨테이너 빌드 및 실행:
   ```
   docker-compose up -d
   ```

2. VS Code Server 접속:
   브라우저에서 다음 URL로 접속하세요:
   ```
   http://localhost:${VSCODE_EXPOSE_PORT}  # 기본값: 8080
   ```
   또는 호스트 환경의 vs code 에디터에서 `명령어 팔레트`를 통해 `실행중인 컨테이너에 연결`하세요.

3. 컨테이너 중지:
   ```
   docker-compose down
   ```

## GCP 인증 확인

컨테이너 내에서 gcp 인스턴스 리스트를 출력하는 명령을 실행하여 GCP 인증이 올바르게 설정되었는지 확인할 수 있습니다:

```bash
gcloud compute instances list
```
위 명령어는 프로젝트 내의 컴퓨터 엔진 인스턴스 목록을 요청합니다.
더 상세한 명령어 안내는 [gcloud cli 공식 문서](https://cloud.google.com/sdk/gcloud/reference)를 참조 하세요.

## VS Code 확장 프로그램

필요한 VS Code 확장 프로그램을 설치하려면 VS Code Server 웹 인터페이스의 확장 탭에서 설치하세요. 주요 추천 확장 프로그램:

- Python
- Docker
- GitLens
- Google Cloud Code

## 프로젝트 개발 usage
이 도커 이미지는 개발용 환경을 제공하려는 목적으로 만들어졌습니다.

### 개별 프로젝트마다 개별 컨테이너 띄우기
이 도커 이미지를 개별 프로젝트 개발용으로 사용 할 경우 프로젝트간 환경 오염을 막으려면 프로젝트 마다 별도의 컨테이너를 띄워 사용하길 권장 합니다.
이 경우 각 컨테이너별 gcloud 설정을 달리 가져갈 수 있다는 장점이 있지만, 같은 설정을 매번 해줘야 하는 단점이 생깁니다.

### 다수 프로젝트를 단독 컨테이너로 띄우기
이 도커 이미지로 띄운 컨테이너 환경을 일종의 원격 개발 컴퓨터로 사용하는 방법입니다.
이를 위해 projects 디렉토리를 만들어 놓았으며, projects 하위의 디렉토리는 개별 git repository일 것으로 간주하였습니다.
따라서 이 환경의 git 레포지토리가 변경을 추적하지 않도록 .gitignore 설정을 해놓았습니다.
```.gitignore
# ...
projects/**/*
!projects/.gitkeep
# ...
```
이 경우로 활용할 때에 위 .gitignore 설정을 삭제 하지 마세요.
또한 이 경우의 장점과 단점은 정확히 이전 항목과 반대입니다.

## 주의 사항

- GCP 서비스 계정 키는 보안상 중요한 정보이므로 안전하게 관리하세요.
- 이 컨테이너는 개발 환경 용도로만 사용하세요. 