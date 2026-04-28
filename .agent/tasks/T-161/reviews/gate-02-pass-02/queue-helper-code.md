Approval: APPROVE

The prior phantom active-owner issue is fixed: the real claim path now deep-copies candidate state before mutation, and the added regression covers the write-block skip case without creating a false lock conflict. No blocking file/line issues found.
