{ lib }:

{
  name = "lessbombs";
  fullname = "LESS BOMBS";
  email = "mail@lessbombs.com";

  accentColor = "146,110,228"; # purple!

  # applies the plasma paths workaround; requires rebuilding plasma-workspace
  # recommended to toggle only after configuring plasma to satisfaction
  plasmaHax = lib.mkDefault false;
}