#!/bin/bash

flutter run \
    --dart-define=IV=$IO_HRKLTZ_LOCKR__IV \
    --dart-define=SALT=$IO_HRKLTZ_LOCKR__SALT \
    --dart-define=ITERATION_COUNT=$IO_HRKLTZ_LOCKR__ITERATION_COUNT \
    --dart-define=DERIVED_KEY_LENGTH=$IO_HRKLTZ_LOCKR__DERIVED_KEY_LENGTH