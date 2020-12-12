# Dockerfile action for repo-checkout
FROM dynod/devenv:1.3.0

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
