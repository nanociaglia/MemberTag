#include <sourcemod>
#include <chat-processor>

#undef REQUIRE_PLUGIN
#include <discord_utilities>
#include <SWGM>

char g_sChatTagSteam[20], g_sChatTagDiscord[20];

ConVar 	g_cSteamMemberTag,
		g_cDiscordMemberTag,
		g_cSteamOrDiscord;

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name 		= "MemberTag",
	author 		= "Nano",
	description = "Gives a custom chat tag for those who are in steam group or discord server.",
	version 	= "1.2",
	url 		= "https://steamcommunity.com/id/marianzet1/"
};

public void OnPluginStart()
{
	g_cSteamOrDiscord 		= CreateConVar("sm_member_tag_system", "1", "What do you want to use?. 1 = Steam Group | 2 = Discord. 1 Default");
	g_cSteamMemberTag 		= CreateConVar("sm_member_tag_steam", "[MEMBER]", "Prefix for those who are in steam group");
	g_cDiscordMemberTag 	= CreateConVar("sm_member_tag_discord", "[DISCORD-MEMBER]", "Prefix for those who are in a discord server");
	
	AutoExecConfig(true, "MemberTag");
}

public void OnMapStart()
{
	g_cSteamMemberTag.GetString(g_sChatTagSteam, sizeof(g_sChatTagSteam));
	g_cDiscordMemberTag.GetString(g_sChatTagDiscord, sizeof(g_sChatTagDiscord));
}

public Action CP_OnChatMessage(int& author, ArrayList recipients, char[] flagstring, char[] name, char[] message, bool & processcolors, bool & removecolors)
{
	if(IsClientInGame(author))
	{
		if(!CheckCommandAccess(author, "sm_membertag_override", ADMFLAG_BAN))
		{
			if(g_cSteamOrDiscord.IntValue == 1)
			{
				if(SWGM_IsPlayerValidated(author) && SWGM_InGroup(author))
				{
					char sTag[40];
					Format(sTag, sizeof(sTag), "\x04%s\x03", g_sChatTagSteam);
					
					Format(name, MAXLENGTH_MESSAGE, " %s %s", sTag, name);
					return Plugin_Changed;
				}
			}
			else if(g_cSteamOrDiscord.IntValue == 2)
			{
				if(DU_IsMember(author))
				{
					char sTag[40];
					Format(sTag, sizeof(sTag), "\x04%s\x03", g_sChatTagDiscord);
					
					Format(name, MAXLENGTH_MESSAGE, " %s %s", sTag, name);
					return Plugin_Changed;
				}
			}
		}
	}

	return Plugin_Continue;
}