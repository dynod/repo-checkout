# Dockerfile action for repo-checkout
FROM dynod/devenv:1.1.0

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
