#
# InstanceSelector.ps1
#

# Select. Pick random instances out of the group with provided probability. Chaos will draw a random number and if
# that random number is lower than probability then it will proceed to select an instance (at random) out of the
# group. If the random number is higher than the provided probability then no instance will be selected and
# <b>null</b> will be returned.
#
# When the probability value is bigger than 1, say N + 0.x, it will first applies the algorithm described above
# with the probability value as 0.x to select possibly one instance, then it will randomly pick N instances.
#
# The probability is the run probability. If Chaos is running hourly between 9am and 3pm with an overall configured
# probability of "1.0" then the probability provided to this routine would be 1.0/6 (6 hours in 9am-3pm). So the
# typical probability here would be .1666. For Chaos to select an instance it will pick a random number between 0
# and 1. If that random number is less than the .1666 it will proceed to select an instance and return it,
# otherwise it will return null. Over 6 runs it is likely that the random number be less than .1666, but it is not
# certain.
#
# To make Chaos select an instance with 100% certainty it would have to be configured to run only once a day and
# the instance group would have to be configured for "1.0" daily probability.
#
# @param group
#            the group
# @param probability
#            the probability per run that an instance should be terminated.
# @return the instance
