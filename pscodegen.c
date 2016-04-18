#include "heading.h"

std::string stringBuilder(int n_args, ...) {
	std::stringstream ss;
	va_list vl;
	va_start(vl, n_args);
	for (int i = 1; i <= n_args; i++) {
		char* arg = va_arg(vl, char*);
		if (i < n_args)
			ss << arg << " ";
		else
			ss << arg;
	}
	va_end(vl);
	return ss.str();
}

std::string stringBuilder(int n_args, std::string d, ...) {
	std::stringstream ss;
	va_list vl;
	va_start(vl, n_args);
	for (int i = 1; i <= n_args; i++) {
		char* arg = va_arg(vl, char*);
		if (i < n_args)
			ss << arg << d;
		else
			ss << arg;
	}
	va_end(vl);
	return ss.str();
}
