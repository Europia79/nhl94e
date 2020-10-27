#include "pch.h"
#include "Form1.h"
#include "AddressMapping.h"
#include "TeamData.h"
#include "Utils.h"

enum class Team
{
    Anaheim = 0x0,
    Boston = 0x1,
    Buffalo = 0x2,
    Calgary = 0x3,
    Chicago = 0x4,
    Dallas = 0x5,
    Detroit = 0x6,
    Edmonton = 0x7,
    Florida = 0x8,
    Hartford = 0x9,
    LAKings = 0xA,
    Montreal = 0xB,
    NewJersey = 0xC,
    NYIslanders = 0xD,
    NYRangers = 0xE,
    Ottawa = 0xF,
    Philly = 0x10,
    Pittsburgh = 0x11,
    Quebec = 0x12,
    SanJose = 0x13,
    StLouis = 0x14,
    TampaBay = 0x15,
    Toronto = 0x16,
    Vancouver = 0x17,
    Washington = 0x18,
    Winnepeg = 0x19,
    AllStarsEast = 0x1A,
    AllStarsWest = 0x1B
};

std::vector<unsigned char> romData;

class RomDataIterator
{
    int m_fileOffset;

public:
    RomDataIterator(int initialFileOffset)
        : m_fileOffset(initialFileOffset)
    {
    }

    int GetROMOffset()
    {
        return FileOffsetToROMAddress(m_fileOffset);
    }

    void SkipHeader()
    {
        unsigned char headerLength0 = romData[m_fileOffset + 0];
        unsigned char headerLength1 = romData[m_fileOffset + 1];
        m_fileOffset += 2;

        assert(headerLength0 > 0x2 && headerLength1 == 0x0);

        int headerLengthPlusLengthWord = (headerLength1 << 8) | (headerLength0);
        assert(headerLengthPlusLengthWord > 2);
        int headerLength = headerLengthPlusLengthWord - 2;

        m_fileOffset += headerLength;
    }

    std::vector<unsigned char> LoadHeader()
    {
        unsigned char headerLength0 = romData[m_fileOffset + 0];
        unsigned char headerLength1 = romData[m_fileOffset + 1];
        m_fileOffset += 2;

        assert(headerLength0 > 0x2 && headerLength1 == 0x0);

        int headerLengthPlusLengthWord = (headerLength1 << 8) | (headerLength0);
        assert(headerLengthPlusLengthWord > 2);
        int headerLength = headerLengthPlusLengthWord - 2;

        std::vector<unsigned char> result;
        for (int i = 0; i < headerLength; ++i)
        {
            result.push_back(romData[m_fileOffset + i]);
        }
        m_fileOffset += headerLength;

        return result;
    }

    void SaveHeader(std::vector<unsigned char> const& header)
    {
        int headerLength = static_cast<int>(header.size());
        int headerLengthPlusLengthWord = headerLength + 2;
        unsigned char headerLengthPlusLengthWord0 = headerLengthPlusLengthWord & 0xFF;
        unsigned char headerLengthPlusLengthWord1 = (headerLengthPlusLengthWord >> 8) & 0xFF;

        romData[m_fileOffset + 0] = headerLengthPlusLengthWord0;
        romData[m_fileOffset + 1] = headerLengthPlusLengthWord1;
        m_fileOffset += 2;

        for (int i = 0; i < headerLength; ++i)
        {
            romData[m_fileOffset + i] = header[i];
        }
        m_fileOffset += headerLength;
    }

    std::string LoadROMString()
    {
        unsigned char stringLength0 = romData[m_fileOffset + 0];
        unsigned char stringLength1 = romData[m_fileOffset + 1];
        m_fileOffset += 2;

        // Special sentinel values are used to denote empty string
        if (stringLength0 == 0x02 && stringLength1 == 0x0)
            return "";

        int stringLengthPlusLengthWord = (stringLength1 << 8) | (stringLength0);
        assert(stringLengthPlusLengthWord > 2);
        int stringLength = stringLengthPlusLengthWord - 2;

        std::string result;
        for (int i = 0; i < stringLength; ++i)
        {
            result.push_back(romData[m_fileOffset + i]);
        }
        m_fileOffset += stringLength;

        return result;
    }

    void SaveROMString(std::string const& str)
    {
        int strLength = static_cast<int>(str.size());
        int strLengthPlusLengthWord = strLength + 2;
        unsigned char strLengthPlusLengthWord0 = strLengthPlusLengthWord & 0xFF;
        unsigned char strLengthPlusLengthWord1 = (strLengthPlusLengthWord >> 8) & 0xFF;

        romData[m_fileOffset + 0] = strLengthPlusLengthWord0;
        romData[m_fileOffset + 1] = strLengthPlusLengthWord1;
        m_fileOffset += 2;

        for (int i = 0; i < strLength; ++i)
        {
            romData[m_fileOffset + i] = str[i];
        }
        m_fileOffset += strLength;
    }

    int LoadDecimalNumber()
    {
        unsigned char numberByte = romData[m_fileOffset];
        unsigned char numberTens = (numberByte >> 4) & 0xF;
        unsigned char numberOnes = (numberByte & 0xF);
        ++m_fileOffset;
        return (numberTens * 10) + numberOnes;
    }

    void SaveDecimalNumber(int n)
    {
        unsigned char numberTens = n / 10;
        unsigned char numberOnes = n % 10;
        unsigned char resultByte = (numberTens << 4) | numberOnes;
        romData[m_fileOffset] = resultByte;
        ++m_fileOffset;
    }

    void LoadHalfByteNumbers(int* a, int* b)
    {
        unsigned char stat = romData[m_fileOffset];
        unsigned char weightFactor = (stat >> 4) & 0xF;
        *a = weightFactor;

        unsigned char baseAgility = (stat & 0xF);
        *b = baseAgility;

        ++m_fileOffset;
    }

    void SaveHalfByteNumbers(int a, int b)
    {
        assert(a <= 0xf);
        assert(b <= 0xf);
        unsigned char resultByte = (a << 4) | b;
        romData[m_fileOffset] = resultByte;
        ++m_fileOffset;
    }

    void SaveDelimiter()
    {
        romData[m_fileOffset] = 0x02;
        ++m_fileOffset;
        romData[m_fileOffset] = 0x00;
        ++m_fileOffset;
    }

    void SaveLongAddress4Bytes(int addr) // big endian-to-little-endian
    {
        romData[m_fileOffset] = addr & 0xFF;
        addr >>= 8;
        ++m_fileOffset;

        romData[m_fileOffset] = addr & 0xFF;
        addr >>= 8;
        ++m_fileOffset;

        romData[m_fileOffset] = addr & 0xFF;
        addr >>= 8;
        ++m_fileOffset;

        romData[m_fileOffset] = 0;
        ++m_fileOffset;

        assert(addr == 0); // 24-byte address expected
    }

    void SaveByte(int b)
    {
        assert(b > 0 && b < 256);
        romData[m_fileOffset] = b;
        ++m_fileOffset;
    }
};

TeamData GetTeamData(int playerDataAddress)
{
    TeamData result;

    result.SourceDataROMAddress = playerDataAddress;

    RomDataIterator iter(ROMAddressToFileOffset(playerDataAddress));

    result.Header = iter.LoadHeader();

    for (int playerIndex = 0; playerIndex < 30; ++playerIndex)
    {
        PlayerData p{};
        p.OriginalROMAddress = iter.GetROMOffset();
        p.ReplacedROMAddressForRename = 0;
        p.Name = iter.LoadROMString();

        // Convention: empty name string means we reached the end.
        if (p.Name.length() == 0)
            break;

        p.PlayerNumber = iter.LoadDecimalNumber();

        iter.LoadHalfByteNumbers(&p.WeightFactor, &p.BaseAgility);
        p.WeightInPounds = 140 + (p.WeightFactor * 8);

        iter.LoadHalfByteNumbers(&p.BaseSpeed, &p.BaseOffAware);
        iter.LoadHalfByteNumbers(&p.BaseDefAware, &p.BaseShotPower);

        iter.LoadHalfByteNumbers(&p.BaseChecking, &p.HandednessValue);
        p.WhichHandedness = p.HandednessValue % 2 == 0 ? Handedness::Left : Handedness::Right;

        iter.LoadHalfByteNumbers(&p.BaseStickHandling, &p.BaseShotAccuracy);
        iter.LoadHalfByteNumbers(&p.BaseEndurance, &p.DontKnow);
        iter.LoadHalfByteNumbers(&p.BasePassAccuracy, &p.BaseAggression);

        result.Players.push_back(p);
    }

    result.TeamCity = iter.LoadROMString();
    result.Acronym = iter.LoadROMString();
    result.TeamName = iter.LoadROMString();
    result.Venue = iter.LoadROMString();

    return result;
}

std::vector<TeamData> LoadPlayerNamesAndStats()
{
    // Look up the player data pointer table, stored at 0x9CA5E7 in ROM memory map or 0xE25E7 in the ROM file.
    // This is a 28-element array with one element per team.
    // Each element is a pointer to where the team's player data is.

    std::vector<int> playerDataPointers;

    {
        int playerDataPointerTableROMOffset = 0x9CA5E7;
        int fileOffset = ROMAddressToFileOffset(playerDataPointerTableROMOffset);

        for (int teamIndex = 0; teamIndex < 28; ++teamIndex)
        {
            unsigned char b0 = romData[fileOffset + 0];
            unsigned char b1 = romData[fileOffset + 1];
            unsigned char b2 = romData[fileOffset + 2];
            unsigned char b3 = romData[fileOffset + 3];

            int pointer = (b3 << 24) | (b2 << 16) | (b1 << 8) | (b0 << 0);
            playerDataPointers.push_back(pointer);

            fileOffset += 4;
        }
    }

    std::vector<TeamData> result;
    for (int teamIndex = 0; teamIndex < 28; ++teamIndex)
    {
        result.push_back(GetTeamData(playerDataPointers[teamIndex]));
    }

    return result;
}

System::Void CppCLRWinformsProjekt::Form1::exitToolStripMenuItem_Click(System::Object^ sender, System::EventArgs^ e)
{
	this->Close();
}

System::String^ IntToCliString(int n)
{
    std::ostringstream strm;
    strm << n;
    return gcnew System::String(strm.str().c_str());
}

void CppCLRWinformsProjekt::Form1::AddTeam(TeamData const& montreal)
{
    // Declare variables
    System::Windows::Forms::DataGridView^ dataGridView1;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column1;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column2;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column3;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column4;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column5;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column6;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column7;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column8;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column9;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column10;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column11;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column12;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column13;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column14;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column15;
    System::Windows::Forms::DataGridViewTextBoxColumn^ Column16;

    // Create objects
    dataGridView1 = (gcnew System::Windows::Forms::DataGridView());
    Column1 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column2 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column3 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column4 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column5 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column6 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column7 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column8 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column9 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column10 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column11 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column12 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column13 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column14 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column15 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());
    Column16 = (gcnew System::Windows::Forms::DataGridViewTextBoxColumn());

    System::Windows::Forms::TabPage^ tabPage1;

    tabPage1 = (gcnew System::Windows::Forms::TabPage());

    tabPage1->SuspendLayout();

    this->tabControl1->Controls->Add(tabPage1);

    Column1->HeaderText = L"Player Name";
    Column1->Name = L"Column1";
    Column1->ReadOnly = true;

    Column2->HeaderText = L"#";
    Column2->Name = L"Column2";
    Column2->Width = 25;
    Column2->ReadOnly = true;

    Column3->HeaderText = L"Weight Class";
    Column3->Name = L"Column3";
    Column3->Width = 50;
    Column3->ReadOnly = true;

    Column4->HeaderText = L"Agility";
    Column4->Name = L"Column4";
    Column4->Width = 40;
    Column4->ReadOnly = true;

    Column5->HeaderText = L"Speed";
    Column5->Name = L"Column5";
    Column5->Width = 40;
    Column5->ReadOnly = true;

    Column6->HeaderText = L"Off Aware";
    Column6->Name = L"Column6";
    Column6->Width = 40;
    Column6->ReadOnly = true;

    Column7->HeaderText = L"Def Aware";
    Column7->Name = L"Column7";
    Column7->Width = 40;
    Column7->ReadOnly = true;

    Column8->HeaderText = L"Shot Power";
    Column8->Name = L"Column8";
    Column8->Width = 40;
    Column8->ReadOnly = true;

    Column9->HeaderText = L"Checking";
    Column9->Name = L"Column9";
    Column9->Width = 60;
    Column9->ReadOnly = true;

    Column10->HeaderText = L"Hand";
    Column10->Name = L"Column10";
    Column10->Width = 40;
    Column10->ReadOnly = true;

    Column11->HeaderText = L"Stick Handling";
    Column11->Name = L"Column11";
    Column11->Width = 50;
    Column11->ReadOnly = true;

    Column12->HeaderText = L"Shot Acc";
    Column12->Name = L"Column12";
    Column12->Width = 40;
    Column12->ReadOnly = true;

    Column13->HeaderText = L"Endurance";
    Column13->Name = L"Column13";
    Column13->Width = 70;
    Column13->ReadOnly = true;

    Column14->HeaderText = L"Reserved";
    Column14->Name = L"Column14";
    Column14->Width = 60;
    Column14->ReadOnly = true;

    Column15->HeaderText = L"Pass Acc";
    Column15->Name = L"Column15";
    Column15->Width = 40;
    Column15->ReadOnly = true;

    Column16->HeaderText = L"Aggression";
    Column16->Name = L"Column16";
    Column16->Width = 70;
    Column16->ReadOnly = true;

    tabPage1->Controls->Add(dataGridView1);
    tabPage1->Location = System::Drawing::Point(4, 22);
    tabPage1->Name = L"tabPage1";
    tabPage1->Padding = System::Windows::Forms::Padding(3);
    tabPage1->Size = System::Drawing::Size(401, 496);
    tabPage1->TabIndex = 0;
    System::String^ teamAcronym = gcnew System::String(montreal.Acronym.c_str());
    tabPage1->Text = teamAcronym;
    tabPage1->UseVisualStyleBackColor = true;

    dataGridView1->AllowUserToAddRows = false;
    dataGridView1->AllowUserToDeleteRows = false;
    dataGridView1->ColumnHeadersHeightSizeMode = System::Windows::Forms::DataGridViewColumnHeadersHeightSizeMode::AutoSize;
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column1 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column2 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column3 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column4 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column5 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column6 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column7 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column8 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column9 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column10 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column11 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column12 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column13 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column14 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column15 });
    dataGridView1->Columns->AddRange(gcnew cli::array< System::Windows::Forms::DataGridViewColumn^  >(1) { Column16 });
    dataGridView1->Dock = System::Windows::Forms::DockStyle::Fill;
    dataGridView1->Location = System::Drawing::Point(3, 3);
    dataGridView1->Name = L"dataGridView1";
    dataGridView1->Size = System::Drawing::Size(395, 490);
    dataGridView1->TabIndex = 0;

    dataGridView1->Rows->Clear();

    for (size_t i = 0; i < montreal.Players.size(); ++i)
    {
        PlayerData const& player = montreal.Players[i];

        System::String^ playerNameString = gcnew System::String(player.Name.c_str());

        System::String^ playerNumberString = IntToCliString(player.PlayerNumber);
        System::String^ weightClassString = IntToCliString(player.WeightFactor);
        System::String^ agilityString = IntToCliString(player.BaseAgility);
        System::String^ speedString = IntToCliString(player.BaseSpeed);
        System::String^ offAwareString = IntToCliString(player.BaseOffAware);
        System::String^ defAwareString = IntToCliString(player.BaseDefAware);
        System::String^ shotPowerString = IntToCliString(player.BaseShotPower);
        System::String^ checkingString = IntToCliString(player.BaseChecking);
        System::String^ handednessString = player.WhichHandedness == Handedness::Left ? L"L" : L"R";
        System::String^ stickHandlingString = IntToCliString(player.BaseStickHandling);
        System::String^ shotAccString = IntToCliString(player.BaseShotAccuracy);
        System::String^ enduranceString = IntToCliString(player.BaseEndurance);
        System::String^ reservedString = IntToCliString(player.DontKnow);
        System::String^ passAccString = IntToCliString(player.BasePassAccuracy);
        System::String^ aggressionString = IntToCliString(player.BaseAggression);

        dataGridView1->Rows->Add(gcnew cli::array<System::String^>(16) 
        { 
            playerNameString, 
            playerNumberString, 
            weightClassString, 
            agilityString,
            speedString,
            offAwareString,
            defAwareString,
            shotPowerString,
            checkingString,
            handednessString,
            stickHandlingString,
            shotAccString,
            enduranceString,
            reservedString,
            passAccString,
            aggressionString
        });
    }

    tabPage1->ResumeLayout(false);
}

System::Void CppCLRWinformsProjekt::Form1::Form1_Load(System::Object^ sender, System::EventArgs^ e)
{
	std::wstring romFilename = L"E:\\Emulation\\SNES\\Images\\nhl94e.sfc";
	romData = LoadBytesFromFile(romFilename.c_str());

    // Check size
    size_t expectedSize = 0x400000;
    if (romData.size() != expectedSize)
    {
        std::wostringstream sstream;
        sstream << "This program is designed to work on a Super Nintendo NHL '94 ROM which has been expanded to 32 Mbit (4MB).\n";
        sstream << "Use Lunar Expand or other similar tools to perform expansion.\n";
        sstream << "Unexpected size detected: found " << romData.size() << " bytes, expected " << expectedSize << " bytes.\n";

        System::String^ dialogString = gcnew System::String(sstream.str().c_str());
        MessageBox::Show(dialogString);
    }

    std::vector<TeamData> allTeams = LoadPlayerNamesAndStats();

    for (int teamIndex = 0; teamIndex < allTeams.size(); ++teamIndex)
    {
        TeamData const& team = allTeams[teamIndex];
        AddTeam(team);
    }

    tabControl1->SelectedIndex = (int)Team::Montreal;
}