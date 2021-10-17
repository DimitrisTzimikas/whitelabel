/* Libraries */
import React from 'react';
import {Text, useColorScheme, View} from 'react-native';
import {Colors} from 'react-native/Libraries/NewAppScreen';
import SectionStyle from './Section.style';

interface SectionProps {
  title: string;
}

const Section: React.FC<SectionProps> = props => {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={SectionStyle.sectionContainer}>
      <Text
        style={[
          SectionStyle.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {props.title}
      </Text>
      <Text
        style={[
          SectionStyle.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {props.children}
      </Text>
    </View>
  );
};

export default Section;
