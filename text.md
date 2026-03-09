a)
We assume that facility types are defined as enums.

We made strikes weak, because a strike depends on the existence of the user that got the strike.

We assume that it is possible to register for multiple sessions taking place at the same time.

We assume that staff can have other roles and responsibilities than just instructors. A staff member can for example be stationed in the centers counter.

We separated the registered relation from the attended relation. This could be done as a single relation, but would open the possibility for null values. By introducing a separate relation for keeping track of attendance we increase redundancy, since the attended and registered relation contain similar information, but eliminates the possibility of null values.

Based on information found on Sit's website we concluded that it was suficient to have openingtimes as an attribute of Center, since it was consistent for all days of the week.

The following constraints are not displayed in the ER-diagram:

- Constraints on maximum number of attendees for each group session.
- Constraints tied to deadlines. This includes group sessions opening for registration, and deregistration deadline to avoid strikes.
- Multiple sessions cannot take place in the same room at the same time, and an instructor cannot be instructor in two different sessions at the same time.
- Limitations on registration based on memberships in sport clubs for relevant group sessions.
- Limitations on registration based on strikes.
