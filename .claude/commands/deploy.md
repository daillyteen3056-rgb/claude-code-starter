Deploy the current branch to the $ARGUMENTS environment.

Steps:
1. Run the test suite. Abort on failure.
2. Build the Docker image tagged with `$(git rev-parse --short HEAD)`.
3. Push to the registry.
4. Run `helmfile apply -e $ARGUMENTS`.
5. Tail the rollout: `kubectl rollout status deployment/api -n $ARGUMENTS`.
6. Report any pods not Ready after 5 minutes.

Do NOT deploy if there are uncommitted changes. Say so and stop.
Do NOT deploy to prod without an explicit confirmation from the user.
