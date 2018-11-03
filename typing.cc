#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include <conio.h>
#include <windows.h>

using std::cout;
using std::endl;
using std::fstream;
using std::string;
using std::vector;

vector<string> paragraphs;
string title;
int lid;
int index;
char ch;

void setCursorPosition(int x, int y) {
  HANDLE winHandle;
  COORD pos;
  pos.X = y;
  pos.Y = x;
  winHandle = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleCursorPosition(winHandle, pos);
}

void setFontColor(int color) {
  HANDLE hConsole;
  hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hConsole, color);
}

void start() {
  setCursorPosition(0, 0);
  cout << "             " << title << endl;
  setCursorPosition(0, 0);
  cout << "             ";
  setFontColor(14);
  for (int i = 0; i < title.size(); ++i) {
    cout << title[i];
    Sleep(50);
  }
  setFontColor(7);
  lid = 0;
  while (lid < paragraphs.size()) {
    string line = paragraphs[lid];
    index = 0;
    while (line[index] == ' ') index++;
    setCursorPosition(lid + 2, index);
    while (index < line.size()) {
      char c, ch = line[index];
      while ((c = getch()) != ch) {
        setFontColor(12);
        cout << ch;
        Sleep(200);
        setCursorPosition(lid + 2, index);
        setFontColor(7);
        cout << ch;
        setCursorPosition(lid + 2, index);
      }
      setFontColor(14);
      cout << ch;
      setFontColor(7);
      index++;
      setCursorPosition(lid + 2, index);
    }
    lid++;
  }
}

int main() {
  fstream fs;
  const char* const path = "passage1.txt";
  fs.open(path, std::ios::in);

  std::getline(fs, title);
  cout << endl << endl;

  string line;
  while (std::getline(fs, line)) {
    paragraphs.push_back(line);
    cout << line << endl;
  }

  start();
}