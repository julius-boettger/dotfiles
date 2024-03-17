/* this file contains config variables that are not
   necessarily shared by all of my devices, but need
   to be defined in order to build this configuration. */
{
    # networking host name of this device
    networking.hostName = "nixos";
    # global git config
    git.name = "username";
    git.email = "mail@provider.com";
    # server tcp port for barrier
    barrier.port = 20000;
    # firefox profile to customize (can stay like this for now, will be set later)
    firefox.profile = "test";
}