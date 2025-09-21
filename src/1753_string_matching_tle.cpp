#include <iostream>

int main() {
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);

    std::string str;
    std::getline(std::cin, str);

    std::string pattern;
    std::getline(std::cin, pattern);

    int result = 0;

    if (str.length() == pattern.length()) {
        int x = 1;
        for (size_t i = 0; i < str.length(); ++i) {
            if (str[i] != pattern[i]) {
                x = 0;
                break;
            }
        }
        result += x;
    } else if (str.length() > pattern.length()) {
        for (size_t i = 0; i < str.length(); ++i) {
            if (str[i] == pattern[0]) {
                int x = 1;
                for (size_t j = 1;
                     j < pattern.length() && (i + j) <= str.length(); ++j) {
                    if (str[i + j] != pattern[j]) {
                        x = 0;
                        break;
                    }
                }
                result += x;
            }
        }
    }

    std::cout << result << "\n";

    return 0;
}
