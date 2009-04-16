local L = LibStub("AceLocale-3.0"):NewLocale("EPGP", "zhCN")
if not L then return end

L["Alts"] = "\233\169\172\231\148\178"
L["A member is awarded EP"] = "\228\184\128\229\144\141\228\188\154\229\145\152\232\162\171\229\165\150\229\138\177EP"
L["A member is credited GP"] = "\228\184\128\229\144\141\228\188\154\229\145\152\232\162\171\232\174\176\229\133\165GP"
L["Announce"] = "\233\128\154\229\145\138"
L["Announce medium"] = "\233\128\154\229\145\138\229\170\146\228\187\139"
L["Announcement of EPGP actions"] = "EPGP\229\138\168\228\189\156\233\128\154\229\145\138"
L["Announces all EPGP actions to the specified medium."] = "\233\128\154\229\145\138\229\133\168\233\131\168EPGP\229\138\168\228\189\156\232\135\179\230\140\135\229\174\154\229\170\146\228\187\139."
L["Announces EPGP actions to the specified medium."] = "\233\128\154\229\145\138EPGP\229\138\168\228\189\156\232\135\179\230\140\135\229\174\154\229\170\146\228\187\139."
L["Announce when:"] = "\230\173\164\230\151\182\233\128\154\229\145\138:"
L["Automatic boss kill tracking"] = "\232\135\170\229\138\168\232\191\189\232\184\170\229\135\187\230\157\128\233\166\150\233\162\134"
L["Automatic boss tracking"] = "\232\135\170\229\138\168\232\191\189\232\184\170\233\166\150\233\162\134"
L["Automatic boss tracking by means of a popup to mass award EP to the raid and standby when a boss is killed."] = "\232\135\170\229\138\168\232\191\189\232\184\170\233\166\150\233\162\134\229\128\159\229\138\169\229\188\185\229\135\186\230\161\134\229\156\168\229\135\187\230\157\128\233\166\150\233\162\134\229\144\142\231\190\164\228\189\147\229\165\150\229\138\177EP\231\187\153\229\155\162\229\145\152\229\143\138\229\190\133\229\145\189\228\186\186\229\145\152."
L["Automatic handling of the standby list through whispers when in raid. When this is enabled, the standby list is cleared after each reward."] = "\229\155\162\233\152\159\230\180\187\229\138\168\228\184\173\233\128\154\232\191\135\229\175\134\232\175\173\232\135\170\229\138\168\229\164\132\231\144\134\229\190\133\229\145\189\229\144\141\229\141\149. \229\166\130\229\144\175\231\148\168,\230\175\143\230\172\161\229\165\150\229\138\177\229\144\142\229\190\133\229\145\189\229\144\141\229\141\149\229\176\134\232\162\171\230\184\133\231\169\186."
L["Automatic loot tracking"] = "\232\135\170\229\138\168\232\191\189\232\184\170\230\139\190\229\143\150"
L["Automatic loot tracking by means of a popup to assign GP to the toon that received loot. This option only has effect if you are in a raid and you are either the Raid Leader or the Master Looter."] = "\232\135\170\229\138\168\232\191\189\232\184\170\230\139\190\229\143\150\229\128\159\229\138\169\229\188\185\229\135\186\230\161\134\228\184\186\232\142\183\229\190\151\230\136\152\229\136\169\229\147\129\231\154\132\232\167\146\232\137\178\230\140\135\229\174\154GP. \228\187\133\229\189\147\228\189\160\229\156\168\229\155\162\233\152\159\228\184\173\228\184\148\228\184\186\229\155\162\233\149\191\230\136\150\231\137\169\229\147\129\229\136\134\233\133\141\232\128\133\230\151\182\230\173\164\233\128\137\233\161\185\230\150\185\230\156\137\230\149\136."
L["Automatic loot tracking threshold"] = "\232\135\170\229\138\168\232\191\189\232\184\170\230\139\190\229\143\150\231\154\132\229\147\129\232\180\168\231\149\140\233\153\144"
L["Award EP"] = "\229\165\150\229\138\177EP"
L["Base GP should be a positive number"] = "BaseGP(\232\163\133\229\164\135\229\159\186\231\161\128\229\136\134\230\149\176)\229\186\148\228\184\186\230\173\163\230\149\176"
L["Boss"] = "\233\166\150\233\162\134"
L["Credit GP"] = "\232\174\176\229\133\165GP"
L["Credit GP to %s"] = "\229\175\185 %s \232\174\176\229\133\165GP"
L["Custom announce channel name"] = "\232\135\170\229\174\154\228\185\137\233\128\154\229\145\138\233\162\145\233\129\147\229\144\141\231\167\176"
L["Decay"] = "\232\161\176\229\135\143"
L["Decay EP and GP by %d%%?"] = "\228\187\165 %d%% \232\161\176\229\135\143EP\229\143\138GP?"
L["Decay of EP/GP by %d%%"] = "\228\187\165 %d%% \232\161\176\229\135\143EP/GP"
L["Decay Percent should be a number between 0 and 100"] = "\232\161\176\229\135\143\231\142\135\231\154\132\229\128\188\229\186\148\228\187\139\228\186\1420\232\135\179100\228\185\139\233\151\180"
L["Decay=%s%% BaseGP=%s MinEP=%s Extras=%s%%"] = "\232\161\176\229\135\143=%s%% BaseGP=%s MinEP=%s \233\153\132\229\138\160=%s%%"
L["%+d EP (%s) to %s"] = "%+d EP (%s) \231\187\153 %s"
L["%+d GP (%s) to %s"] = "%+d GP (%s) \231\187\153 %s"
L["%d or %d"] = "%d \230\136\150 %d"
L["Do you want to resume recurring award (%s) %d EP/%s?"] = "\228\189\160\230\131\179\233\135\141\230\150\176\229\188\128\229\167\139\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177 (%s) %d EP/%s \229\144\151?"
L["Enable announcement of all EPGP actions to the specified medium."] = "\233\128\154\229\145\138\229\133\168\233\131\168EPGP\229\138\168\228\189\156\232\135\179\230\140\135\229\174\154\229\170\146\228\187\139."
L["Enable announce of actions"] = "\229\144\175\231\148\168\229\138\168\228\189\156\233\128\154\229\145\138"
L["Enable a proposed GP value of armor on tooltips. Quest items or tokens that can be traded with armor will also have a proposed GP value."] = "\229\156\168\231\137\169\229\147\129\228\191\161\230\129\175\230\143\144\231\164\186\228\184\173\230\152\190\231\164\186\232\163\133\229\164\135\231\154\132GP\229\187\186\232\174\174\229\128\188. \228\187\187\229\138\161\231\137\169\229\147\129\230\136\150\229\143\175\231\148\168\228\186\142\228\186\164\230\141\162\232\163\133\229\164\135\231\154\132\228\187\163\229\184\129\228\185\159\229\176\134\230\156\137\228\184\128\228\184\170GP\229\187\186\232\174\174\229\128\188."
L["Enable automatic boss tracking by means of a popup to mass award EP to the raid and standby when a boss is killed."] = "\229\144\175\231\148\168\232\135\170\229\138\168\232\191\189\232\184\170\233\166\150\233\162\134. \229\135\187\230\157\128\233\166\150\233\162\134\229\144\142\233\128\154\232\191\135\229\188\185\229\135\186\230\161\134\231\190\164\228\189\147\229\165\150\229\138\177EP\231\187\153\229\155\162\229\145\152\229\143\138\229\190\133\229\145\189\228\186\186\229\145\152."
L["Enable automatic handling of the standby list through whispers when in raid. When this option is selected the standby list is cleared after each reward"] = "\229\144\175\231\148\168\229\155\162\233\152\159\230\180\187\229\138\168\228\184\173\233\128\154\232\191\135\229\175\134\232\175\173\232\135\170\229\138\168\229\164\132\231\144\134\229\190\133\229\145\189\228\186\186\229\145\152\229\144\141\229\141\149. \229\166\130\233\128\137\228\184\173\230\173\164\233\161\185,\230\175\143\230\172\161\229\165\150\229\138\177\228\185\139\229\144\142\229\190\133\229\145\189\228\186\186\229\145\152\229\144\141\229\141\149\228\188\154\232\162\171\230\184\133\231\169\186."
L["Enable automatic loot tracking"] = "\229\144\175\231\148\168\232\135\170\229\138\168\232\191\189\232\184\170\230\139\190\229\143\150"
L["Enable automatic loot tracking by means of a popup to assign GP to the toon that received loot. This option only has effect if you are in a raid and you are either the Raid Leader or the Master Looter."] = "\229\144\175\231\148\168\232\135\170\229\138\168\232\191\189\232\184\170\230\139\190\229\143\150. \228\184\186\232\142\183\229\190\151\230\136\152\229\136\169\229\147\129\231\154\132\232\167\146\232\137\178\233\128\154\232\191\135\229\188\185\229\135\186\230\161\134\230\157\165\230\140\135\229\174\154GP. \228\187\133\229\189\147\228\189\160\229\156\168\229\155\162\233\152\159\228\184\173\228\184\148\228\184\186\229\155\162\233\149\191\230\136\150\229\136\134\233\133\141\232\128\133\230\151\182\230\173\164\233\128\137\233\161\185\230\150\185\230\156\137\230\149\136."
L["Enable GP on tooltips"] = "\229\156\168\231\137\169\229\147\129\228\191\161\230\129\175\230\143\144\231\164\186\228\184\173\230\152\190\231\164\186GP"
L["Enable standby whispers in raid"] = "\229\144\175\231\148\168\229\155\162\233\152\159\230\180\187\229\138\168\228\184\173\229\175\134\232\175\173\229\190\133\229\145\189\228\186\186\229\145\152"
L["EP/GP are reset"] = "EP/GP \229\183\178\232\162\171\233\135\141\231\189\174"
L["EPGP decay"] = "EPGP\232\161\176\229\135\143"
L["EPGP is an in game, relational loot distribution system"] = "EPGP\230\152\175\228\184\128\228\184\170\230\184\184\230\136\143\229\134\133\231\189\174\231\154\132\229\133\179\232\129\148\229\188\143\230\136\152\229\136\169\229\147\129\229\136\134\233\133\141\231\179\187\231\187\159"
L["EPGP is using Officer Notes for data storage. Do you really want to edit the Officer Note by hand?"] = "EPGP\228\189\191\231\148\168\229\174\152\229\145\152\229\164\135\230\179\168\229\173\152\229\130\168\230\149\176\230\141\174. \231\161\174\229\174\154\232\166\129\230\137\139\229\138\168\228\191\174\230\148\185\229\174\152\229\145\152\229\164\135\230\179\168\228\185\136?"
L["EPGP reset"] = "EPGP\233\135\141\231\189\174"
L["EP Reason"] = "EP\231\144\134\231\148\177"
L["Export"] = "\229\175\188\229\135\186"
L["Extras Percent should be a number between 0 and 100"] = "\233\153\132\229\138\160\231\142\135\231\154\132\229\128\188\229\186\148\228\187\139\228\186\1420\232\135\179100\228\185\139\233\151\180"
L["GP: %d [ItemLevel=%d]"] = "GP: %d [\231\137\169\229\147\129\231\173\137\231\186\167=%d]"
L["GP: %d or %d [ItemLevel=%d]"] = "GP: %d \230\136\150 %d [\231\137\169\229\147\129\231\173\137\231\186\167=%d]"
L["GP on tooltips"] = "\228\191\161\230\129\175\230\143\144\231\164\186\228\184\173\231\154\132GP"
L["GP Reason"] = "GP\229\142\159\229\155\160"
L["Guild or Raid are awarded EP"] = "\229\133\172\228\188\154\230\136\150\229\155\162\233\152\159\232\162\171\229\165\150\229\138\177EP"
L["Hint: You can open these options by typing /epgp config"] = "\230\143\144\231\164\186: \228\189\160\229\143\175\233\128\154\232\191\135\233\148\174\229\133\165 /epgp config \230\157\165\230\152\190\231\164\186\232\191\153\228\186\155\233\128\137\233\161\185"
L["If you want to be on the award list but you are not in the raid, you need to whisper me: 'epgp standby' or 'epgp standby <name>' where <name> is the toon that should receive awards"] = "\229\166\130\230\158\156\228\189\160\230\131\179\232\191\155\229\133\165\229\165\150\229\138\177\229\144\141\229\141\149\229\141\180\228\184\141\229\156\168\229\155\162\233\152\159\228\184\173,\233\130\163\228\185\136\228\189\160\229\191\133\233\161\187\229\144\145\230\136\145\229\175\134\232\175\173: 'epgp standby' \230\136\150 'epgp standby <\232\167\146\232\137\178\229\144\141>' \230\173\164<\232\167\146\232\137\178\229\144\141>\229\186\148\228\184\186\230\142\165\229\143\151\229\165\150\229\138\177\231\154\132\232\167\146\232\137\178."
L["Ignoring EP change for unknown member %s"] = "\229\191\189\231\149\165\229\175\185\230\156\170\231\159\165\228\188\154\229\145\152%s\232\191\155\232\161\140\231\154\132EP\230\148\185\229\138\168"
L["Ignoring GP change for unknown member %s"] = "\229\191\189\231\149\165\229\175\185\230\156\170\231\159\165\228\188\154\229\145\152%s\232\191\155\232\161\140\231\154\132GP\230\148\185\229\138\168"
L["Ignoring non-existent member %s"] = "\229\191\189\231\149\165\228\184\141\229\173\152\229\156\168\231\154\132\228\188\154\229\145\152 %s"
L["Import"] = "\229\175\188\229\133\165"
L["Importing data snapshot taken at: %s"] = "\229\175\188\229\133\165%s\230\151\182\230\136\170\229\143\150\231\154\132\230\149\176\230\141\174\229\191\171\231\133\167"
L["Invalid officer note [%s] for %s (ignored)"] = "\230\151\160\230\149\136\229\174\152\229\145\152\229\164\135\230\179\168 [%s] \232\162\171\232\181\139\228\186\136 %s (\229\183\178\229\191\189\231\149\165)"
L["List errors"] = "\229\136\151\229\135\186\233\148\153\232\175\175"
L["Lists errors during officer note parsing to the default chat frame. Examples are members with an invalid officer note."] = "\229\156\168\233\187\152\232\174\164\232\129\138\229\164\169\230\161\134\230\158\182\228\184\173\229\136\151\229\135\186\232\167\163\230\158\144\229\174\152\229\145\152\229\164\135\230\179\168\230\151\182\229\143\145\231\148\159\231\154\132\233\148\153\232\175\175. \228\190\139\229\166\130\229\133\183\230\156\137\230\151\160\230\149\136\229\174\152\229\145\152\229\164\135\230\179\168\231\154\132\228\188\154\229\145\152."
L["Loot"] = "\230\139\190\229\143\150"
L["Loot tracking threshold"] = "\230\139\190\229\143\150\232\191\189\232\184\170\231\149\140\233\153\144"
L["Mass EP Award"] = "\231\190\164\228\189\147EP\229\165\150\229\138\177"
L["Min EP should be a positive number"] = "MinEP(\230\156\128\228\189\142\232\180\161\231\140\174\231\130\185\230\149\176)\229\186\148\228\184\186\230\173\163\230\149\176"
L["Next award in "] = "\232\183\157\231\166\187\228\184\139\230\172\161\229\165\150\229\138\177"
L["Other"] = "\229\133\182\229\174\131"
L["Personal Action Log"] = "\228\184\170\228\186\186\230\147\141\228\189\156\232\174\176\229\189\149"
L["Provide a proposed GP value of armor on tooltips. Quest items or tokens that can be traded for armor will also have a proposed GP value."] = "\229\156\168\231\137\169\229\147\129\228\191\161\230\129\175\230\143\144\231\164\186\228\184\173\230\143\144\228\190\155\232\163\133\229\164\135\231\154\132GP\229\187\186\232\174\174\229\128\188. \228\187\187\229\138\161\231\137\169\229\147\129\230\136\150\229\143\175\231\148\168\228\186\142\228\186\164\230\141\162\232\163\133\229\164\135\231\154\132\228\187\163\229\184\129\228\185\159\229\176\134\230\156\137\228\184\128\228\184\170GP\229\187\186\232\174\174\229\128\188."
L["Recurring"] = "\229\190\170\231\142\175"
L["Recurring awards resume"] = "\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177\233\135\141\230\150\176\229\188\128\229\167\139"
L["Recurring awards start"] = "\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177\229\188\128\229\167\139"
L["Recurring awards stop"] = "\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177\231\187\147\230\157\159"
L["Redo"] = "\233\135\141\229\129\154"
L["Reset all main toons' EP and GP to 0?"] = "\233\135\141\231\189\174\230\137\128\230\156\137\229\164\167\229\143\183\231\154\132EP\229\143\138GP\228\184\1860\229\144\151?"
L["Reset EPGP"] = "\233\135\141\231\189\174EPGP"
L["Resets EP and GP of all members of the guild. This will set all main toons' EP and GP to 0. Use with care!"] = "\233\135\141\231\189\174\229\133\168\228\189\147\229\133\172\228\188\154\230\136\144\229\145\152\231\154\132EP\229\143\138GP, \230\173\164\230\147\141\228\189\156\229\176\134\233\135\141\231\189\174\230\137\128\230\156\137\229\164\167\229\143\183\231\154\132EP\229\143\138GP\228\184\1860. \230\133\142\233\135\141\228\189\191\231\148\168!"
L["Resume recurring award (%s) %d EP/%s"] = "\233\135\141\230\150\176\229\188\128\229\167\139\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177 (%s) %d EP/%s"
L["Rollback EPGP"] = "\230\129\162\229\164\141EPGP"
L["Rollbacks to the latest snapshot of EPGP taken at logout"] = "\230\129\162\229\164\141\232\135\179\231\153\187\229\135\186\230\184\184\230\136\143\230\151\182\230\136\170\229\143\150\231\154\132\230\156\128\230\150\176EPGP\229\191\171\231\133\167"
L["Rollback to snapshot taken on %s?"] = "\230\129\162\229\164\141\232\135\179%s\230\151\182\230\136\170\229\143\150\231\154\132\229\191\171\231\133\167\229\144\151?"
L["%s: %+d EP (%s) to %s"] = "%s: %+d EP (%s) \231\187\153 %s"
L["%s: %+d GP (%s) to %s"] = "%s: %+d GP (%s) \231\187\153 %s"
L["Sets automatic loot tracking threshold, to disable the popup on loot below this threshold quality."] = "\232\174\190\231\189\174\232\135\170\229\138\168\232\191\189\232\184\170\230\139\190\229\143\150\231\154\132\231\149\140\233\153\144, \228\189\191\229\190\151\230\139\190\229\143\150\228\189\142\228\186\142\230\173\164\229\147\129\232\180\168\231\149\140\233\153\144\231\154\132\231\137\169\229\147\129\230\151\182\231\166\129\231\148\168\229\188\185\229\135\186\230\161\134."
L["Sets loot tracking threshold, to disable the popup on loot below this threshold quality."] = "\232\174\190\231\189\174\230\139\190\229\143\150\232\191\189\232\184\170\229\147\129\232\180\168\231\149\140\233\153\144, \228\189\191\230\139\190\229\143\150\228\189\142\228\186\142\232\174\190\229\174\154\229\147\129\232\180\168\231\149\140\233\153\144\231\154\132\231\137\169\229\147\129\230\151\182\231\166\129\231\148\168\229\188\185\229\135\186\230\161\134."
L["Sets the announce medium EPGP will use to announce EPGP actions."] = "\232\174\190\231\189\174\231\148\168\230\157\165\233\128\154\229\145\138EPGP\229\138\168\228\189\156\231\154\132EPGP\233\128\154\229\145\138\229\170\146\228\187\139."
L["Sets the custom announce channel name used to announce EPGP actions."] = "\232\174\190\231\189\174\231\148\168\230\157\165\233\128\154\229\145\138EPGP\229\138\168\228\189\156\231\154\132\232\135\170\229\174\154\228\185\137\233\128\154\229\145\138\233\162\145\233\129\147\229\144\141\231\167\176."
L["Set the announce medium"] = "\232\174\190\231\189\174\233\128\154\229\145\138\229\170\146\228\187\139"
L["Show everyone"] = "\230\152\190\231\164\186\230\137\128\230\156\137\228\186\186"
L["%s is added to the award list"] = "%s \232\162\171\230\183\187\229\138\160\232\191\155\229\165\150\229\138\177\229\144\141\229\141\149\228\184\173"
L["%s is already in the award list"] = "%s \229\183\178\231\187\143\229\156\168\229\165\150\229\138\177\229\144\141\229\141\149\228\184\173\228\186\134"
L["%s is dead. Award EP?"] = "%s \232\162\171\229\135\187\230\157\128. \229\165\150\229\138\177EP?"
L["%s is not eligible for EP awards"] = "%s \230\151\160\232\181\132\230\160\188\232\142\183\229\190\151EP\229\165\150\229\138\177"
L["%s is now removed from the award list"] = "\229\183\178\228\187\142\229\165\150\229\138\177\229\144\141\229\141\149\228\184\173\231\167\187\233\153\164\228\186\134 %s"
L["Standby whispers in raid"] = "\229\143\145\233\128\129\229\175\134\232\175\173\231\154\132\229\190\133\229\145\189\228\186\186\229\145\152"
L["Start recurring award (%s) %d EP/%s"] = "\229\188\128\229\167\139\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177 (%s) %d EP/%s"
L["Stop recurring award"] = "\229\129\156\230\173\162\229\145\168\230\156\159\230\128\167\229\165\150\229\138\177"
L["The imported data is invalid"] = "\229\175\188\229\133\165\230\149\176\230\141\174\230\151\160\230\149\136"
L["To export the current standings, copy the text below and post it to the webapp: http://epgpweb.appspot.com"] = "\232\166\129\229\175\188\229\135\186\229\189\147\229\137\141\231\167\175\229\136\134\232\161\168, \233\156\128\229\164\141\229\136\182\229\166\130\228\184\139\230\150\135\230\156\172\229\185\182\229\176\134\229\133\182\229\143\145\229\184\131\232\135\179\231\189\145\231\187\156\231\168\139\229\186\143 http://epgpweb.appspot.com"
L["Tooltip"] = "\228\191\161\230\129\175\230\143\144\231\164\186"
L["To restore to an earlier version of the standings, copy and paste the text from the webapp: http://epgpweb.appspot.com here"] = "\232\166\129\230\129\162\229\164\141\231\167\175\229\136\134\232\161\168\228\184\186\230\151\169\229\137\141\231\137\136\230\156\172, \233\156\128\228\187\142\231\189\145\231\187\156\231\168\139\229\186\143 http://epgpweb.appspot.com \229\164\141\229\136\182\229\185\182\231\178\152\232\180\180\230\150\135\230\156\172\232\135\179\230\173\164"
L["Undo"] = "\230\146\164\233\148\128"
L["Using DBM for boss kill tracking"] = "\231\148\168DBM\232\191\189\232\184\170\229\135\187\230\157\128\233\166\150\233\162\134"
L["Value"] = "\230\149\176\229\128\188"
L["Whisper"] = "\229\175\134\232\175\173"
