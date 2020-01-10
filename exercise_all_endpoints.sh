function exercise_registrations {
    curl -i -XPOST -H"Content-Type: application/json" registration-pal-badname.apps.evans.pal.pivotal.io/registration -d'{"name": "$2"}'
    curl -i registration-pal-badname.apps.evans.pal.pivotal.io/users/$1
}

function exercise_projects {
    curl -i -XPOST -H"Content-Type: application/json" registration-pal-badname.apps.evans.pal.pivotal.io/projects -d"{\"name\": \"$2\", \"accountId\": $1}"
    curl -i registration-pal-badname.apps.evans.pal.pivotal.io/projects?accountId=$1
}

function exercise_allocations {
    curl -i -XPOST -H"Content-Type: application/json" allocations-pal-badname.apps.evans.pal.pivotal.io/allocations -d"{\"projectId\": $1, \"userId\": $2, \"firstDay\": \"2015-05-17\", \"lastDay\": \"2015-05-18\"}"
    curl -i allocations-pal-badname.apps.evans.pal.pivotal.io/allocations?projectId=$1
}

function exercise_stories {
    curl -i -XPOST -H"Content-Type: application/json" backlog-pal-badname.apps.evans.pal.pivotal.io/stories -d"{\"projectId\": $1, \"name\": \"$2\"}"
    curl -i backlog-pal-badname.apps.evans.pal.pivotal.io/stories?projectId=$1
}

function exercise_time_entries {
    curl -i -XPOST -H"Content-Type: application/json" timesheets-pal-badname.apps.evans.pal.pivotal.io/time-entries/ -d"{\"projectId\": $1, \"userId\": $2, \"date\": \"2015-05-17\", \"hours\": 6}"
    curl -i timesheets-pal-badname.apps.evans.pal.pivotal.io/time-entries?userId=$2
}

function submit_multiproject {
    cd ~/workspace/assignment-submission
    ./gradlew $1 \
        -PregistrationServerUrl=https://registration-pal-badname.apps.evans.pal.pivotal.io \
        -PbacklogServerUrl=https://backlog-pal-badname.apps.evans.pal.pivotal.io \
        -PallocationsServerUrl=https://allocations-pal-badname.apps.evans.pal.pivotal.io \
        -PtimesheetsServerUrl=https://timesheets-pal-badname.apps.evans.pal.pivotal.io
    cd -
}