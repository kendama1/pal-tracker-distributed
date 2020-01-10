function trim_ws {
    sed 's/^[[:space:]]*//' <<< "$1"
}

function exercise_registrations {
    POST_RESULT=$(curl -s -XPOST -H"Content-Type: application/json" registration-pal-badname.apps.evans.pal.pivotal.io/registration -d"{\"name\": \"$1\"}" | jq .)
    echo -e "\n\nPOST"
    echo $POST_RESULT | jq .
    GET_RESULT=$(curl -s registration-pal-badname.apps.evans.pal.pivotal.io/users/$(echo $POST_RESULT | jq '.id'))
    echo -e "\n\nGET"
    echo $GET_RESULT | jq .
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

function unbind_and_delete {
    cf delete-service-key -f $2 flyway-migration-key
    sleep 10s
    cf unbind-service $1 $2
    sleep 10s
    cf delete-service -f $2
    sleep 10s
}

function create_dbs {
    cf create-service p.mysql db-small $1
}

function cleanup_databases {
    unbind_and_delete tracker-allocations tracker-allocations-database
    sleep 10s
    unbind_and_delete tracker-backlog tracker-backlog-database
    sleep 10s
    unbind_and_delete tracker-timesheets tracker-timesheets-database
    sleep 10s
    unbind_and_delete tracker-registration tracker-registration-database
    sleep 10s
}

function rebuild_databases {
    create_dbs {tracker-allocations,tracker-backlog,tracker-timesheets,tracker-registration}-database
}

function bad_travis {
    ./gradlew clean build
    cleanup_databases
    rebuild_databases
    sleep 10m
    cf push -f manifest-{registration,allocations,backlog,timesheets}.yml
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