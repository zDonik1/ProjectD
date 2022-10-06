pipeline {
    agent { docker 'barichello/godot-ci:3.5.1' }
    environment {
        EXPORT_NAME = 'DungeonCrawler'
        DEBUG_EXPORT_NAME = $EXPORT_NAME-debug
    }
    stages {
        stage('Export') {
            steps {
                sh '''
                mkdir -v -p build/android
                cd $EXPORT_NAME
                godot -v --no-window --export-debug Android build/android/$DEBUG_EXPORT_NAME.apk
                '''
            }
        }
    }
    post {
        success {
            archiveArtifacts '$DEBUG_EXPORT_NAME.apk'
        }
    }
}
