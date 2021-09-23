# XRL Mute Box
A great 3D printed XLR mute box with an illuminated front and button.

# Technical Background
Note, that the contacts of your button need a very low contact resistance of about 50 mOhm. To bypass that (these small miniature buttons are often ugly) and make even big illuminated buttons available, we make use of an electromechanical relay.

The relay (and the LED) is powered over a DC 5 Volt jack using a USB cable. A relay with 5 Volt will fit perfectly. Often only 12 Volt versions are available. But don't worry, we have a solution for that.

### Shorting Pin 2 & 3 together

How does muting XLR work? Well – to be precise you won't be able to mute an XLR connection to 100%. Any XLR mute box you can buy is actually not muting, but lowering the level significally [typically greater than 50 dB](https://service.shure.com/s/article/mute-switch-with-phantom-power?language=en_US); thus, the signal becomes inaudible for human ears.

The reason for that is, that the preferred (and safe) method used relys on a short between Pin 2 and Pin 3. This causes the signal to be neutralized. Whenever we refer to a short in an electrical circuit we think about a zero (0) resistance, but in fact, there is nothing in the world with no resistance. You always have one. There is a very little rest signal. It is inaudible, but you can restore it by raising the level by 50 dB for instance.

As a result of that we can say:

The box will work perfectly for you if you're streamer and only want to mute you while eating, sneezing and coughing - or if you're doing music at home, at the stage. But it should not be used in any environment where full-mute is required due to security concerns. In this rare case you need to rely on a digital rather than a analog mute.

### Why not disconnecting Pin 1 or Pin 2 & 3?

Possible of course; however that causes the microphone to be discharged, thus resulting in disturbing cracking or popping sounds. Also, this method is way slower. While shorting Pin 2 & 3 lets you mute *and* unmute the microphone even multiple times within seconds, your microphone will need a couple of seconds to be ready once unmuted again.
