# Gate 3 Pass 2: Queue And Scope

Finding: `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` was dirty even though T-167's allowed write scope does not include the generated project file.

Required correction before approval: remove generated project churn from the final diff or justify it with an allowed `project.yml` change. Queue state/result/review/proof files were otherwise within T-167 scope.

Approval: BLOCK
