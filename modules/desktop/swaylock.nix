{...}: {
  # PAM configuration for swaylock
  security.pam.services.swaylock = {
    text = ''auth include login '';
  };
}
